import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_cook/module/home/controller/foodClassController.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/toast.dart';
import '../cook/views/cook_config_cell.dart';
import '../cook/model/cook_config_model.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

class FoodClassPage extends GetView<FoodDataController> {
  const FoodClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.foodData.text ?? "--"),
        backgroundColor: ThemeManager.themeColor,
      ),
      body: ListView.builder(
        itemCount: controller.foodData.data!.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(controller.foodData.data![index].text ?? ""),
                titleAlignment: ListTileTitleAlignment.center,
                leading: Container(
                    padding: EdgeInsets.all(8.0),
                    width: 80,
                    height: 100,
                    child: GFImageOverlay(
                      image: NetworkImage(
                          controller.foodData.data![index].image ?? ''),
                      boxFit: BoxFit.cover, //填充模式
                      borderRadius: BorderRadius.circular(5.0), //圆角
                    )),
                trailing: Image(
                  image: AssetImage('assets/images/arrow_right.png'),
                  width: 20,
                  height: 18,
                ),
                onTap: () {
                  _classConfigCook(controller.foodData.data![index]);
                },
              ),
              Divider(
                height: 0.5, // 分割线的高度
                color: ThemeManager.lineBoardColor(),
              ),
            ],
          );
        },
      ),
    );
  }

  _classConfigCook(FoodSubData data) {
    Map<String, dynamic>? arguments = {
      'methodName': 'CategorySearch',
      'version': '4.3.2',
      'cat_id': data.id,
      'type': data.type,
    };

    Get.toNamed('/cookConfig', arguments: arguments);
  }
}
