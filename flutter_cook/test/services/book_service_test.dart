import 'package:dio/dio.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  test('菜谱服务必须保留接口分页总量而不是只返回当前页列表', () async {
    final client = MockDioClient();
    final service = BookService(client: client);
    final payload = {
      'data': {
        'page': 1,
        'size': 20,
        'total': 1460,
        'count': 1,
        'data': [
          {
            'dish_count': 140,
            'scene_id': 865,
            'scene_title': '日常保肝餐',
          },
        ],
      },
    };

    when(() => client.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response<Map<String, dynamic>>(
        data: payload,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result = await service.fetchBookList(page: 1);

    expect(result, isNot(isA<List<BookListModel>>()));
    expect((result as dynamic).totalCount, 1460);
    expect((result as dynamic).items, hasLength(1));
    expect((result as dynamic).items.first.dishCount, 140);
  });

  test('菜谱详情组合专题元数据并一次性加载全部分页菜谱', () async {
    final client = MockDioClient();
    final service = BookService(client: client);
    when(() => client.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((invocation) async {
      final query =
          invocation.namedArguments[#queryParameters] as Map<String, dynamic>;
      final methodName = query['methodName'] as String;
      final page = query['page'] as int? ?? 1;

      if (methodName == 'SceneInfo') {
        return Response<Map<String, dynamic>>(
          data: const {
            'data': {
              'scene_id': 1280,
              'scene_title': '儿童长高食谱',
              'scene_desc': '营养搭配',
              'dish_count': 45,
              'dishes_list': <Map<String, dynamic>>[],
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );
      }

      final start = (page - 1) * 20;
      final count = page < 3 ? 20 : 5;
      return Response<Map<String, dynamic>>(
        data: {
          'data': {
            'page': page,
            'size': 20,
            'total': 45,
            'data': List.generate(
              count,
              (index) => {
                'dishes_id': start + index + 1,
                'dishes_name': '菜谱 ${start + index + 1}',
              },
            ),
          },
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );
    });

    final result = await service.fetchBookDetail(1280, page: 1);
    final dishes = result.data?.dishesList ?? const <BookDishesListModel>[];

    expect(result.data?.sceneTitle, '儿童长高食谱');
    expect(result.data?.dishCount, 45);
    expect(dishes, hasLength(45));
    expect(dishes.first.dishesId, 1);
    expect(dishes.last.dishesId, 45);

    final captured = verify(() => client.get(
          any(),
          queryParameters: captureAny(named: 'queryParameters'),
        )).captured.cast<Map<String, dynamic>>();
    expect(
      captured.where((query) => query['methodName'] == 'SceneDishes'),
      hasLength(3),
    );
  });
}
