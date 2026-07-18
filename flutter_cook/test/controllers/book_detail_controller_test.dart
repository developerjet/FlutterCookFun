import 'dart:async';

import 'package:flutter_cook/module/book/controller/book_detail_controller.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  test('不同详情页面拥有完全独立的数据状态', () async {
    final service = MockBookService();
    when(() => service.fetchBookDetail(1, page: 1)).thenAnswer(
      (_) async => const BookDetailModel(
        data: BookMoreData(
          sceneId: 1,
          dishesList: [BookDishesListModel(dishesId: 11)],
        ),
      ),
    );
    when(() => service.fetchBookDetail(2, page: 1)).thenAnswer(
      (_) async => const BookDetailModel(
        data: BookMoreData(
          sceneId: 2,
          dishesList: [BookDishesListModel(dishesId: 22)],
        ),
      ),
    );
    final first = BookDetailController(service: service, sceneId: 1);
    final second = BookDetailController(service: service, sceneId: 2);

    await first.load();

    expect(first.dishes.single.dishesId, 11);
    expect(second.detail.value, isNull);
    expect(second.dishes, isEmpty);

    await second.load();

    expect(first.dishes.single.dishesId, 11);
    expect(second.dishes.single.dishesId, 22);
  });

  test('页面销毁后迟到的详情请求不得更新状态', () async {
    final service = MockBookService();
    final completer = Completer<BookDetailModel>();
    when(() => service.fetchBookDetail(1, page: 1))
        .thenAnswer((_) => completer.future);
    final controller = BookDetailController(service: service, sceneId: 1);

    final loading = controller.load();
    controller.dispose();
    completer.complete(
      const BookDetailModel(
        data: BookMoreData(
          sceneId: 1,
          dishesList: [BookDishesListModel(dishesId: 11)],
        ),
      ),
    );
    await loading;

    expect(controller.detail.value, isNull);
    expect(controller.dishes, isEmpty);
  });
}
