import 'package:flutter_cook/base/web.dart';
import 'package:flutter_cook/binding/binding.dart';
import 'package:flutter_cook/module/book/book_detial_page.dart';
import 'package:flutter_cook/module/cook/cook_config_page.dart';
import 'package:flutter_cook/module/cook/cook_steps_page.dart';
import 'package:flutter_cook/module/home/home_class_page.dart';
import 'package:flutter_cook/module/mine/favorites_page.dart';
import 'package:flutter_cook/module/player/player_page.dart';
import 'package:flutter_cook/module/setting/setting_page.dart';
import 'package:get/get.dart';

import '../base/tabs.dart';
import '../module/search/search_page.dart';
import '../module/setting/setting_page.dart';

class AppPage {
  // 路由配置
  static final routers = [
    // TabBar
    GetPage(name: "/", page: () => const Tabs()),

    // 首页食材分类
    GetPage(
        name: "/foodClass",
        binding: AllControllerBinding(),
        page: () => const FoodClassPage(),
        transition: Transition.cupertino), // iOS风格的过渡动画

    // 做菜步骤
    GetPage(
        name: "/cookSteps",
        page: () => const CookStepsPage(),
        transition: Transition.cupertino),

    // 去配菜界面
    GetPage(
        name: "/cookConfig",
        page: () => const CookConfigPage(),
        transition: Transition.cupertino),

    // 做菜步骤界面
    GetPage(
        name: "/cookSteps",
        page: () => const CookStepsPage(),
        transition: Transition.cupertino),

    // 视频播放界面
    GetPage(
        name: "/player",
        page: () => PlayerVideoPage(),
        transition: Transition.cupertino),

    // 菜谱详情列表
    GetPage(
        name: "/bookDetail",
        page: () => BookDetailPage(),
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
      binding: AllControllerBinding(),
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
        page: () => WebViewPage(),
        transition: Transition.cupertino),
  ];
}
