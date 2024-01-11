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
          'settting_title': '设置',
          'change_theme': '切换主题',
          'light_theme': '白天模式',
          'dark_theme': '夜间模式',
          'setting_language': '设置语言',
          'language_zh': '中文',
          'language_en': '英文',
        },
        'en_US': {
          'app_name_title': 'Cooking fun',
          'tab_home_title': 'Home',
          'tab_cook_title': 'Cook',
          'tab_book_title': 'Book',
          'tab_mine_title': 'My',
          'settting_title': 'Settings',
          'change_theme': 'Set theme',
          'light_theme': 'Light',
          'dark_theme': 'Dark',
          'setting_language': 'Set language',
          'language_zh': 'Chinese',
          'language_en': 'English',
        }
      };
}
