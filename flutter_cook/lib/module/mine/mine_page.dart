import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/utils/colors.dart';
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
          backgroundColor: CustomColors.themeColor,
        ),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            // 顶部Banner
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: CustomColors.bg3Color(),
                child: Column(children: [
                  SizedBox(height: 30),
                  Image.asset('assets/images/app_logo.png',
                      width: 80, height: 80),
                  SizedBox(height: 15),
                  Text(
                    "厨艺乐",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CustomColors.textMainColor(), fontSize: 15),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "v${_version}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CustomColors.textGrayColor(), fontSize: 13),
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
                                color: CustomColors.textMainColor())),
                        leading: _customLoading(index),
                        trailing: Image.asset('assets/images/arrow_right.png',
                            width: 20, height: 18),
                        onTap: () {
                          _handlerIndexTap(index);
                        },
                      ),
                      Divider(
                        height: 0.5, // 分割线的高度
                        color: CustomColors.lineBoardColor(),
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
        return Icon(Icons.web);

      default:
        return Icon(Icons.data_usage_rounded);
    }
  }
}
