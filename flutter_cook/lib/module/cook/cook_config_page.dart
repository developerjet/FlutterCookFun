import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:flutter_cook/utils/hudLoading.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/toast.dart';
import '../cook/views/cook_config_cell.dart';
import '../cook/model/cook_config_model.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

class CookConfigPage extends StatefulWidget {
  const CookConfigPage({super.key});

  @override
  _CookConfigPageState createState() => _CookConfigPageState();
}

class _CookConfigPageState extends State<CookConfigPage> {
  late List<CookConfigListModel> _dataList = [];

  @override
  void initState() {
    super.initState();

    HudLoading.show('Loading...');
    _fetchConfigCooking();
  }

  // 开始配菜
  Future<void> _fetchConfigCooking() async {
    Map<String, dynamic>? params = Get.arguments;
    final response = await DioClient.get('', queryParameters: params);

    List jsonList = response.data['data']['data'];

    late List<CookConfigListModel> tempList = [];
    HudLoading.dismiss();

    if (jsonList.length > 0) {
      for (var data in jsonList) {
        CookConfigListModel model = CookConfigListModel.fromJson(data);
        tempList.add(model);
      }

      setState(() {
        _dataList = tempList;
      });
    } else {
      // 配菜无效
      _showConfigFailedAlert('所选食材配置失败，可重新选择');
    }
  }

  _showConfigFailedAlert(String msg) {
    Get.dialog(
      AlertDialog(
        title: Text('温馨提示'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: Center(
                child: Text(
              '确定',
              style: TextStyle(color: CustomColors.themeColor),
            )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("可做${_dataList.length}道菜"),
        backgroundColor: CustomColors.themeColor,
      ),
      body: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          return InkWell(
              child: Column(
            children: [
              CookConfigCell(model: _dataList[index]),
              Divider(
                  height: 0.75, // 设置分割线的高度
                  color: CustomColors.lineBoardColor()),
            ],
          ),
          onTap: () {
            // 跳转做菜步骤
            Get.toNamed('/cookSteps', arguments: {'dishes_id': _dataList[index].dishesId});
          },
          );
        },
      ),
    );
  }
}
