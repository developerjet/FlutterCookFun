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
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';

/// 全局依赖注入配置
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ── 基础设施 ──
    _lazyPutPermanent<DioClient>(() => DioClient());
    _lazyPutPermanent<ThemeManager>(() => ThemeManager());

    // ── Services ──
    _lazyPutPermanent<BannerService>(() => BannerService());
    _lazyPutPermanent<CookService>(
        () => CookService(repository: Get.find<CookRepository>()));
    _lazyPutPermanent<BookService>(
        () => BookService(client: Get.find<DioClient>()));

    // ── Repository ──
    _lazyPutPermanent<HomeRepository>(
      () => HomeRepository(
        client: Get.find<DioClient>(),
        bannerService: Get.find<BannerService>(),
      ),
    );
    _lazyPutPermanent<CookRepository>(
        () => CookRepository(client: Get.find<DioClient>()));

    // ── Controller ──
    _lazyPutPermanent<HomeController>(
      () => HomeController(repository: Get.find<HomeRepository>()),
    );
    _lazyPutPermanent<CookHomeController>(
      () => CookHomeController(repository: Get.find<CookRepository>()),
    );
    _lazyPutPermanent<CookConfigController>(
      () => CookConfigController(repository: Get.find<CookRepository>()),
    );
    _lazyPutPermanent<CookStepsController>(
      () => CookStepsController(repository: Get.find<CookRepository>()),
    );
    _lazyPutPermanent<BookController>(
      () => BookController(service: Get.find<BookService>()),
    );
    _lazyPutPermanent<FavoritesController>(() => FavoritesController());
    _lazyPutPermanent<SettingController>(() => SettingController());
  }

  void _lazyPutPermanent<T>(T Function() builder) {
    GetInstance().lazyPut<T>(builder, permanent: true);
  }
}
