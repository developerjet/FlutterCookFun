import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/home/controller/foodClassController.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/utils/sqlite/db_manager.dart';
import '../cook/views/cook_config_cell.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<CookConfigListModel> _dataList = [];
  late List<CookConfigListModel>? _configList;

  /// 获取控制器
  FoodDataController dataController = Get.find();

  @override
  void initState() {
    super.initState();

    _queryAllData();
    _bindDataRefresh();
  }

  _queryAllData() async {
    _configList = await DBManager().findAll();

    setState(() {
      if (_dataList.length > 0) {
        _dataList = [];
      }

      _dataList.addAll(_configList!.reversed.toList());
    });
  }

  _bindDataRefresh() {
    /// 刷新数据
    dataController.favoriteCallback = () {
      print("刷新数据收藏列表数据");

      _queryAllData();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('favorite_title'.tr),
        backgroundColor: ThemeManager.themeColor,
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Column(
              children: [
                CookConfigCell(model: _dataList[index]),
                Divider(
                    height: 0.75, // 设置分割线的高度
                    color: ThemeManager.lineBoardColor()),
              ],
            ),
            onTap: () {
              // 跳转做菜步骤
              Get.toNamed('/cookSteps', arguments: {
                'dishes_id': _dataList[index].dishesId,
                'pushPage': 'myFavorites'
              });
            },
          );
        },
      )),
    );
  }
}
