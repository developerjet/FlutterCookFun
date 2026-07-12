import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';

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
          .thenAnswer((_) async => []);

      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      verify(() => mockService.fetchBookList(page: 1)).called(1);
      expect(controller.bookList, isEmpty);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNull);
    });
  });
}
