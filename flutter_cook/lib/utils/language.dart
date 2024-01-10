import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'app_name_title': '厨易乐',
          'tab_home_title': '首页',
          'tab_cook_title': '烹饪',
          'tab_book_title': '菜谱',
          'tab_mine_title': '我的',
        },
        'en_US': {
          'app_name_title': 'Cooking fun',
          'tab_home_title': 'Home',
          'tab_cook_title': 'Cook',
          'tab_book_title': 'Book',
          'tab_mine_title': 'My',
        }
      };
}
