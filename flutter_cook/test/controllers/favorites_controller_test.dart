import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesDataStore extends Mock implements FavoritesDataStore {}

void main() {
  late MockFavoritesDataStore dataStore;
  late FavoritesController controller;

  setUp(() {
    dataStore = MockFavoritesDataStore();
    when(() => dataStore.findAll()).thenAnswer((_) async => []);
    controller = FavoritesController(dataStore: dataStore);
  });

  group('FavoritesController', () {
    test('removeFavorites deletes selected ids and refreshes memory list',
        () async {
      controller.favoritesList.assignAll([
        const CookConfigListModel(dishesId: '1', title: '菜谱 1'),
        const CookConfigListModel(dishesId: '2', title: '菜谱 2'),
        const CookConfigListModel(dishesId: '3', title: '菜谱 3'),
      ]);
      when(() => dataStore.delete('1')).thenAnswer((_) async => 1);
      when(() => dataStore.delete('3')).thenAnswer((_) async => 1);

      final success = await controller.removeFavorites({'1', '3'});

      expect(success, true);
      expect(controller.favoritesList.map((item) => item.dishesId), ['2']);
      verify(() => dataStore.delete('1')).called(1);
      verify(() => dataStore.delete('3')).called(1);
    });

    test('removeFavorites ignores empty id set', () async {
      controller.favoritesList.assignAll([
        const CookConfigListModel(dishesId: '1', title: '菜谱 1'),
      ]);

      final success = await controller.removeFavorites({});

      expect(success, true);
      expect(controller.favoritesList.map((item) => item.dishesId), ['1']);
      verifyNever(() => dataStore.delete(any()));
    });

    test('removeFavorites refreshes successful deletes when later delete fails',
        () async {
      controller.favoritesList.assignAll([
        const CookConfigListModel(dishesId: '1', title: '菜谱 1'),
        const CookConfigListModel(dishesId: '2', title: '菜谱 2'),
        const CookConfigListModel(dishesId: '3', title: '菜谱 3'),
      ]);
      when(() => dataStore.delete('1')).thenAnswer((_) async => 1);
      when(() => dataStore.delete('3')).thenThrow(Exception('delete failed'));

      final success = await controller.removeFavorites({'1', '3'});

      expect(success, false);
      expect(controller.favoritesList.map((item) => item.dishesId), ['2', '3']);
      verify(() => dataStore.delete('1')).called(1);
      verify(() => dataStore.delete('3')).called(1);
    });
  });
}
