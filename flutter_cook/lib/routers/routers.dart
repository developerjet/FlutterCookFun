import 'package:flutter_cook/base/web.dart';
import 'package:flutter_cook/module/book/book_detial_page.dart';
import 'package:flutter_cook/module/book/binding/book_binding.dart';
import 'package:flutter_cook/module/cook/cook_config_page.dart';
import 'package:flutter_cook/module/cook/cook_steps_page.dart';
import 'package:flutter_cook/base/image_viewer.dart';
import 'package:flutter_cook/module/home/home_class_page.dart';
import 'package:flutter_cook/module/mine/favorites_page.dart';
import 'package:flutter_cook/module/player/player_page.dart';
import 'package:flutter_cook/module/setting/setting_page.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

import '../base/tabs.dart';
import '../module/search/search_page.dart';

class AppRouter {
  // 路由配置
  static final routers = [
    // TabBar
    GetPage(name: "/", page: () => const Tabs()),

    // 首页食材分类
    GetPage(
        name: "/foodClass",
        page: () => const FoodClassPage(),
        transition: Transition.cupertino), // iOS风格的过渡动画

    // 做菜步骤
    GetPage(
        name: RouteNames.cookSteps,
        page: () => const CookStepsPage(),
        transition: Transition.cupertino),

    // 去配菜界面
    GetPage(
        name: RouteNames.cookConfig,
        page: () => const CookConfigPage(),
        transition: Transition.cupertino),

    // 视频播放界面
    GetPage(
        name: RouteNames.playerVideo,
        page: () => const PlayerVideoPage(),
        transition: Transition.cupertino),

    // 菜谱详情列表
    GetPage(
        name: RouteNames.bookDetail,
        binding: BookBinding(),
        page: () => const BookDetailPage(),
        transition: Transition.cupertino),

    // 去设置界面
    GetPage(
      name: "/setting",
      page: () => const SettingPage(),
      transition: Transition.cupertino,
    ),

    // 收藏
    GetPage(
      name: "/favorite",
      page: () => const FavoritePage(),
      transition: Transition.cupertino,
    ),

    // 去搜索界面
    GetPage(
        name: "/search",
        page: () => const SearchPage(),
        transition: Transition.cupertino),

    // Web界面
    GetPage(
        name: "/webPage",
        page: () => const WebViewPage(),
        transition: Transition.cupertino),

    // 图片浏览
    GetPage(
        name: "/imageViewer",
        page: () => const ImageViewer(),
        transition: Transition.cupertino),
  ];
}
