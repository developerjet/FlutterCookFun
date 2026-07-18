import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';

import '../helpers/mocks.dart';

void main() {
  group('BookController', () {
    late MockBookService mockService;
    late BookController controller;

    setUp(() {
      mockService = MockBookService();
      controller = BookController(service: mockService);
    });

    test('onInit loads first page of book list', () async {
      when(() => mockService.fetchBookList(page: 1))
          .thenAnswer((_) async => BookListPage(
                items: const [],
                page: 1,
                pageSize: 20,
                totalCount: 0,
              ));

      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      verify(() => mockService.fetchBookList(page: 1)).called(1);
      expect(controller.bookList, isEmpty);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNull);
    });

    test('stores server total and computes pagination from explicit metadata',
        () async {
      when(() => mockService.fetchBookList(page: 1)).thenAnswer(
        (_) async => BookListPage(
          items: const [
            BookListModel(
              sceneId: 865,
              sceneTitle: '日常保肝餐',
              dishCount: 140,
            ),
          ],
          page: 1,
          pageSize: 20,
          totalCount: 1460,
        ),
      );

      final success = await controller.loadBookList(page: 1);

      expect(success, true);
      expect(controller.totalCount.value, 1460);
      expect(controller.bookHasMore.value, true);
      expect(controller.bookList.single.dishCount, 140);
    });
  });
}
