import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/utils/toast.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String _version = '1.0.0';

  final List<String> items = [
    "设置",
    "我的收藏",
    "Flutter中文网",
    "作者Github",
  ];

  @override
  void initState() {
    super.initState();

    _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // setState(() {
    //   _version = packageInfo.version;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('tab_mine_title'.tr),
          backgroundColor: ThemeManager.themeColor,
        ),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            // 顶部Banner
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: ThemeManager.bg3Color(),
                child: Column(children: [
                  SizedBox(height: 30),
                  Image.asset('assets/images/app_logo.png',
                      width: 80, height: 80),
                  SizedBox(height: 15),
                  Text(
                    "厨艺乐",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ThemeManager.textMainColor(),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Eox"),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "v${_version}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ThemeManager.textGrayColor(),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Eox"),
                  )
                ]),
              ),
            ),
            // 列表数据
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(items[index],
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Exo",
                                color: ThemeManager.textMainColor())),
                        leading: _customLoading(index),
                        trailing: Image.asset('assets/images/arrow_right.png',
                            width: 20, height: 18),
                        onTap: () {
                          _handlerIndexTap(index);
                        },
                      ),
                      Divider(
                        height: 0.5, // 分割线的高度
                        color: ThemeManager.lineBoardColor(),
                      ),
                    ],
                  );
                },
                childCount: items.length,
              ),
            ),
          ],
        )));
  }

  _handlerIndexTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/setting');

      case 1:
        Get.toNamed('/favorite');

      case 2:
        Get.toNamed('/webPage',
            arguments: {'title': 'Flutter中文网', 'url': 'https://flutter.cn'});

      default:
        Get.toNamed('/webPage', arguments: {
          'title': 'Github',
          'url': 'https://github.com/developerjet'
        });
    }
  }

  static Icon _customLoading(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.settings);

      case 1:
        return Icon(Icons.dashboard_customize_sharp);

      case 2:
        return Icon(Icons.web);

      default:
        return Icon(Icons.data_usage_rounded);
    }
  }
}
