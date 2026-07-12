import 'package:get/get.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/services/banner_service.dart';
import 'package:flutter_cook/services/cook_service.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/module/home/repository/home_repository.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/module/home/controller/home_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_config_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_steps_controller.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/search/controller/search_controller.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';

/// 全局依赖注入配置
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ── 基础设施 ──
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    Get.lazyPut<ThemeManager>(() => ThemeManager(), fenix: true);

    // ── Services ──
    Get.lazyPut<BannerService>(() => BannerService());
    Get.lazyPut<CookService>(
        () => CookService(repository: Get.find<CookRepository>()));
    Get.lazyPut<BookService>(
        () => BookService(client: Get.find<DioClient>()));

    // ── Repository ──
    Get.lazyPut<HomeRepository>(() => HomeRepository(
        client: Get.find<DioClient>(),
        bannerService: Get.find<BannerService>()));
    Get.lazyPut<CookRepository>(
        () => CookRepository(client: Get.find<DioClient>()));

    // ── Controller ──
    Get.lazyPut<HomeController>(
        () => HomeController(repository: Get.find<HomeRepository>()));
    Get.lazyPut<CookHomeController>(
        () => CookHomeController(repository: Get.find<CookRepository>()));
    Get.lazyPut<CookConfigController>(
        () => CookConfigController(repository: Get.find<CookRepository>()));
    Get.lazyPut<CookStepsController>(
        () => CookStepsController(repository: Get.find<CookRepository>()));
    Get.lazyPut<BookController>(
        () => BookController(service: Get.find<BookService>()));
    Get.lazyPut<SearchController>(
        () => SearchController(client: Get.find<DioClient>()));
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
