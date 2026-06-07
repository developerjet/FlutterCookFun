import 'package:flutter/material.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

class FoodClassPage extends StatelessWidget {
  const FoodClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = Get.arguments;
    final HomeFoodListData foodData = arguments is HomeFoodListData
        ? arguments
        : HomeFoodListData();

    return Scaffold(
      appBar: AppBar(
        title: Text(foodData.text ?? "--"),
      ),
      body: ListView.builder(
        itemCount: foodData.data?.length ?? 0,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(foodData.data![index].text ?? ""),
                titleAlignment: ListTileTitleAlignment.center,
                leading: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 80,
                    height: 100,
                    child: GFImageOverlay(
                      image: NetworkImage(
                          foodData.data![index].image ?? ''),
                      boxFit: BoxFit.cover, //填充模式
                      borderRadius: BorderRadius.circular(5.0), //圆角
                    )),
                trailing: const Image(
                  image: AssetImage('assets/images/arrow_right.png'),
                  width: 20,
                  height: 18,
                ),
                onTap: () {
                  _classConfigCook(foodData.data![index]);
                },
              ),
              Divider(
                height: 0.5, // 分割线的高度
                color: Theme.of(context).dividerColor,
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

    Get.toNamed(RouteNames.cookConfig, arguments: arguments);
  }
}
