import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/utils/error_handler.dart';

import '../helpers/mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  late MockCookRepository mockRepo;
  late CookHomeController controller;

  setUp(() {
    registerTestDependencies();
    mockRepo = MockCookRepository();
    controller = CookHomeController(repository: mockRepo);
  });

  tearDown(() {
    clearTestDependencies();
  });

  group('CookHomeController', () {
    test('loadCookHomeData sets loading then data on success', () async {
      final mockData = <CookHomeListModel>[];
      when(() => mockRepo.fetchCookHomeData())
          .thenAnswer((_) async => mockData);

      await controller.loadCookHomeData(forceRefresh: true);

      expect(controller.isLoading.value, false);
      expect(controller.cookHomeList.length, 0);
      expect(controller.errorMessage.value, isNull);
    });

    test('loadCookHomeData sets errorMessage on failure', () async {
      when(() => mockRepo.fetchCookHomeData())
          .thenThrow(NetworkException(message: 'test error', code: 'TEST'));

      await controller.loadCookHomeData(forceRefresh: true);

      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNotNull);
    });

    test('toggleFoodSelection selects and deselects item', () {
      final item = CookListDataModel(
        id: '1',
        text: 'test',
        image: '',
        isSelected: false,
      );

      final result1 = controller.toggleFoodSelection(item);
      expect(result1, true);
      expect(item.isSelected.value, true);

      final result2 = controller.toggleFoodSelection(item);
      expect(result2, true);
      expect(item.isSelected.value, false);
    });

    test('toggleFoodSelection enforces max 5 limit', () {
      final items = List.generate(
          6,
          (i) => CookListDataModel(
                id: '$i',
                text: 'item$i',
                image: '',
                isSelected: false,
              ));

      for (int i = 0; i < 5; i++) {
        expect(controller.toggleFoodSelection(items[i]), true);
      }
      expect(controller.selectedCookList.length, 5);
      expect(controller.toggleFoodSelection(items[5]), false);
    });
  });
}
