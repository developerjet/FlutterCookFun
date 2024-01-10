import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../module/home/home_page.dart';
import '../module/cook/cook_page.dart';
import '../module/book/book_page.dart';
import '../module/mine/mine_page.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 顶部导航栏
      appBar: AppBar(
        title: Text("Cook Fun"),
        backgroundColor: Color(0XFF00CC99),
      ),
      // 控制器
      body: _pages[_currentIndex],
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color(0XFF00CC99), //选中的颜色
          // iconSize:35,           //底部菜单大小
          currentIndex: _currentIndex, //第几个菜单选中
          type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
          onTap: (index) {
            //点击菜单触发的方法
            //注意
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/tab_home_none.png', width: 25, height: 25),
                activeIcon: Image.asset('assets/images/tab_home_selected.png', width: 25, height: 25),
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
    );
  }
}
