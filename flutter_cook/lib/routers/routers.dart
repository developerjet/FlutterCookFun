import 'package:flutter_cook/base/web.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_config_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_steps_controller.dart';
import 'package:flutter_cook/module/book/book_detial_page.dart';
import 'package:flutter_cook/module/cook/cook_config_page.dart';
import 'package:flutter_cook/module/cook/cook_steps_page.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/base/image_viewer.dart';
import 'package:flutter_cook/module/home/home_class_page.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/mine/favorites_page.dart';
import 'package:flutter_cook/module/player/player_page.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:flutter_cook/module/setting/setting_page.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';

import '../base/tabs.dart';
import '../module/search/search_page.dart';

class AppRouter {
  // 路由配置
  static final routers = [
    // TabBar
    GetPage(name: RouteNames.home, page: () => const Tabs()),

    // 首页食材分类
    GetPage(
        name: RouteNames.foodClass,
        page: () => const FoodClassPage(),
        transition: Transition.cupertino), // iOS风格的过渡动画

    // 做菜步骤
    GetPage(
        name: RouteNames.cookSteps,
        page: () => const CookStepsPage(),
        binding: BindingsBuilder(_bindCookStepsRoute),
        transition: Transition.cupertino),

    // 去配菜界面
    GetPage(
        name: RouteNames.cookConfig,
        page: () => const CookConfigPage(),
        binding: BindingsBuilder(_bindCookConfigRoute),
        transition: Transition.cupertino),

    // 视频播放界面
    GetPage(
        name: RouteNames.playerVideo,
        page: () => const PlayerVideoPage(),
        transition: Transition.cupertino),

    // 菜谱详情列表
    GetPage(
        name: RouteNames.bookDetail,
        page: () => const BookDetailPage(),
        binding: BindingsBuilder(_bindBookRoute),
        transition: Transition.cupertino),

    // 去设置界面
    GetPage(
      name: RouteNames.setting,
      page: () => const SettingPage(),
      binding: BindingsBuilder(_bindSettingRoute),
      transition: Transition.cupertino,
    ),

    // 收藏
    GetPage(
      name: RouteNames.favorites,
      page: () => const FavoritePage(),
      binding: BindingsBuilder(_bindFavoritesRoute),
      transition: Transition.cupertino,
    ),

    // 去搜索界面
    GetPage(
        name: RouteNames.search,
        page: () => const SearchPage(),
        binding: BindingsBuilder(_bindNetworkRoute),
        transition: Transition.cupertino),

    // Web界面
    GetPage(
        name: RouteNames.web,
        page: () => const WebViewPage(),
        transition: Transition.cupertino),

    // 图片浏览
    GetPage(
        name: RouteNames.imageViewer,
        page: () => const ImageViewer(),
        transition: Transition.cupertino),
  ];

  static void _bindCookConfigRoute() {
    _bindCookRepositoryRoute();
    _lazyPutIfAbsent<CookConfigController>(
      () => CookConfigController(repository: Get.find<CookRepository>()),
    );
  }

  static void _bindCookStepsRoute() {
    _bindCookRepositoryRoute();
    _lazyPutIfAbsent<CookStepsController>(
      () => CookStepsController(repository: Get.find<CookRepository>()),
    );
    _lazyPutIfAbsent<FavoritesController>(() => FavoritesController());
  }

  static void _bindBookRoute() {
    _lazyPutIfAbsent<DioClient>(() => DioClient());
    _lazyPutIfAbsent<BookService>(
      () => BookService(client: Get.find<DioClient>()),
    );
    _lazyPutIfAbsent<BookController>(
      () => BookController(service: Get.find<BookService>()),
    );
  }

  static void _bindFavoritesRoute() {
    _lazyPutIfAbsent<FavoritesController>(() => FavoritesController());
  }

  static void _bindSettingRoute() {
    _lazyPutIfAbsent<ThemeManager>(() => ThemeManager());
    _lazyPutIfAbsent<SettingController>(() => SettingController());
  }

  static void _bindNetworkRoute() {
    _lazyPutIfAbsent<DioClient>(() => DioClient());
  }

  static void _bindCookRepositoryRoute() {
    _lazyPutIfAbsent<DioClient>(() => DioClient());
    _lazyPutIfAbsent<CookRepository>(
      () => CookRepository(client: Get.find<DioClient>()),
    );
  }

  static void _lazyPutIfAbsent<T>(T Function() builder) {
    if (Get.isRegistered<T>()) {
      return;
    }
    Get.lazyPut<T>(builder);
  }
}
