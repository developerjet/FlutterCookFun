import 'package:get/get.dart';

import '../base/tabs.dart';
import '../module/search/search_page.dart';

class AppPage {

  // 路由配置
  static final routers = [
    // TabBar
    GetPage(name: "/", page: () => const Tabs()),
    
    // 去搜索界面
    GetPage(
        name: "/search",
        page: () => const SearchPage()),
  ];
}
