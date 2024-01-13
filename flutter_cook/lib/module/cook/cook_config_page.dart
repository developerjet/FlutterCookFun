import 'dart:ffi';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/theme.dart';
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
  late int pageIndex = 1;
  late List<CookConfigListModel> _dataList = [];

  @override
  void initState() {
    super.initState();

    HudLoading.show('Loading...');
    _fetchConfigCooking();
  }

  // 开始配菜
  Future<void> _fetchConfigCooking() async {
    late Map<String, dynamic> params = Get.arguments;
    params['size'] = 20;
    params['page'] = pageIndex;

    List jsonList = [];
    String methodName = Get.arguments['methodName'];

    final response = await DioClient.get('', queryParameters: params);

    if (methodName == "SearchHome") {
      jsonList = response.data['data']['dishes']['data'];
    } else {
      jsonList = response.data['data']['data'];
    }

    HudLoading.dismiss();

    if (jsonList.length > 0) {
      if (pageIndex == 1) {
        _dataList = [];
      }

      late List<CookConfigListModel> tempList = [];
      for (var data in jsonList) {
        CookConfigListModel model = CookConfigListModel.fromJson(data);
        tempList.add(model);
      }

      setState(() {
        _dataList.addAll(tempList);
      });
    } else {
      // 配菜无效
      if (pageIndex > 1) {
        ToastUtils.showShortToast("暂无更多配菜");
        return;
      }

      _showConfigFailedAlert('所选食材配菜失败，可重新选择');
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
              style: TextStyle(color: ThemeManager.themeColor),
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
        backgroundColor: ThemeManager.themeColor,
      ),
      body: EasyRefresh(
        // 下拉刷新回调
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            pageIndex = 1;
            _fetchConfigCooking();
          });
        },
        // 上拉加载回调
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            pageIndex++;
            _fetchConfigCooking();
          });
        },
        // 控制器
        controller: EasyRefreshController(),
        // 子部件
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
                  'pushPage': 'cookConfig'
                });
              },
            );
          },
        ),
      ),
    );
  }
}
