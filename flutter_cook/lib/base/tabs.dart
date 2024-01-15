import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../module/home/home_data_page.dart';
import '../module/cook/cook_home_page.dart';
import '../module/book/book_home_page.dart';
import '../module/mine/mine_page.dart';
import '../utils/theme.dart';

class Tabs extends StatefulWidget {
  final int index;
  const Tabs({super.key, this.index = 0});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _currentIndex;

  final List<Widget> _pages = [
    HomePage(),
    CookPage(),
    BookPage(),
    MinePage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentIndex = widget.index;
    _handlerThemeMode();
  }

  Future<void> _handlerThemeMode() async {
    int lastTheme = await ThemeManager.fetchLastTheme() ?? 0;
    ThemeManager.saveTheme(lastTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: ThemeManager.tabUnselectedColor,
          fixedColor: ThemeManager.tabSelectedColor, //选中的颜色
          iconSize: 30, //底部菜单大小
          unselectedFontSize: 11,
          selectedFontSize: 11,
          currentIndex: _currentIndex, //第几个菜单选中
          type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
          onTap: (index) {
            //点击菜单触发的方法
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/tab_home_none.png',
                    width: 25, height: 25),
                activeIcon: Image.asset('assets/images/tab_home_selected.png',
                    width: 25, height: 25),
                label: 'tab_home_title'.tr),
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/tab_cook_none.png',
                    width: 24, height: 24),
                activeIcon: Image.asset('assets/images/tab_cook_selected.png',
                    width: 24, height: 24),
                label: 'tab_cook_title'.tr),
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/tab_book_none.png',
                    width: 20, height: 20),
                activeIcon: Image.asset('assets/images/tab_book_seleced.png',
                    width: 20, height: 20),
                label: 'tab_book_title'.tr),
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/tab_mine_none.png',
                    width: 25, height: 25),
                activeIcon: Image.asset('assets/images/tab_mine_selected.png',
                    width: 25, height: 25),
                label: 'tab_mine_title'.tr),
          ]),
      //使用IndexedStack作为body
      body: IndexedStack(
        index: _currentIndex, //当前显示的子组件索引
        children: _pages, //子组件列表
      ),
    );
  }
}
