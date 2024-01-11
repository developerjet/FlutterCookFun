import 'package:flutter_cook/base/web.dart';
import 'package:flutter_cook/binding/binding.dart';
import 'package:flutter_cook/module/cook/cook_config_page.dart';
import 'package:flutter_cook/module/cook/cook_steps_page.dart';
import 'package:flutter_cook/module/home/home_class_page.dart';
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
        page: () => const FoodClassPage()),

    // 做菜步骤
    GetPage(name: "/cookSteps", page: () => const CookStepsPage()),

    // 去配菜界面
    GetPage(name: "/cookConfig", page: () => const CookConfigPage()),

    // 做菜步骤界面
    GetPage(name: "/cookSteps", page: () => const CookStepsPage()),

    // 视频播放界面
    GetPage(name: "/player", page: () => PlayerVideoPage()),

    // 去设置界面
    GetPage(name: "/setting", page: () => const SettingPage()),

    // 去搜索界面
    GetPage(name: "/search", page: () => const SearchPage()),

    // Web界面
    GetPage(name: "/webPage", page: () => WebViewPage()),
  ];
}
