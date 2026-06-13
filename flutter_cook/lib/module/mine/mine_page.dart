import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  final String _version = '1.0.0';
  final List<String> itemKeys = [
    'setting_title',
    'favorite_title',
    'flutter_web',
    'my_github',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('tab_mine_title'.tr),
        ),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            // 顶部Banner
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  const SizedBox(height: 30),
                  Image.asset('assets/images/app_logo.png',
                      width: 80, height: 80),
                  const SizedBox(height: 15),
                  Text(
                    'app_name_title'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Exo"),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "v$_version",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Exo"),
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
                        title: Text(itemKeys[index].tr,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Exo",
                                color: Theme.of(context).textTheme.bodyLarge?.color)),
                        leading: _customLoading(index),
                        trailing: Image.asset('assets/images/arrow_right.png',
                            width: 20, height: 18),
                        onTap: () {
                          _handlerIndexTap(index);
                        },
                      ),
                      Divider(
                        height: 0.5, // 分割线的高度
                        color: Theme.of(context).dividerColor,
                      ),
                    ],
                  );
                },
                childCount: itemKeys.length,
              ),
            ),
          ],
        )));
  }

  _handlerIndexTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/setting');
        break;
      case 1:
        Get.toNamed('/favorite');
        break;
      case 2:
        Get.toNamed('/webPage', arguments: {
          'title': 'flutter_web'.tr,
          'url': 'https://flutter.cn'
        });
        break;
      default:
        Get.toNamed('/webPage', arguments: {
          'title': 'my_github'.tr,
          'url': 'https://github.com/developerjet'
        });
        break;
    }
  }

  static Icon _customLoading(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.settings);

      case 1:
        return const Icon(Icons.dashboard_customize_sharp);

      case 2:
        return const Icon(Icons.web);

      default:
        return const Icon(Icons.data_usage_rounded);
    }
  }
}
