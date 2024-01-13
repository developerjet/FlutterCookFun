import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/views/cook_home_cell.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:flutter_cook/utils/hudLoading.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

class CookPage extends StatefulWidget {
  const CookPage({Key? key}) : super(key: key);

  @override
  _CookPageState createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  // 每次最大可选食材
  static const int _maxFoodCount = 5;

  late List<CookHomeListModel> dataList = [];
  final List<CookListDataModel> _selectedList = [];

  //响应式变量
  final RxString _cookingName = "".obs;

  @override
  void initState() {
    super.initState();

    HudLoading.show('Loading...');
    _fetchCooksData();
  }

  // 获取食材数据
  Future<void> _fetchCooksData() async {
    Map<String, dynamic>? params = {
      'methodName': 'MaterialSubtype',
      'version': '4.3.2',
    };

    final response = await DioClient.get('', queryParameters: params);
    List jsonList = response.data['data']['data'];

    HudLoading.dismiss();

    if (jsonList.length > 0) {
      List<CookHomeListModel> tempList = [];
      for (var data in jsonList) {
        CookHomeListModel model = CookHomeListModel.fromJson(data);
        tempList.add(model);
      }

      setState(() {
        dataList = tempList;
      });
    }
  }

  _handlerSelectFood(CookListDataModel model) {
    if (_selectedList.length >= _maxFoodCount) {
      ToastUtils.showShortToast("每次最多可选食材$_maxFoodCount种");
      return;
    }

    _selectedList.add(model);

    // 数组转字符串，用符号隔开
    String result = _selectedList.map((val) => val.text.toString()).join(', ');
    _cookingName.value = result;
  }

  _showDeleteAlert() {
    if (_selectedList.length == 0) {
      ToastUtils.showSnackbar("温馨提示", "您还未选择食材");
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text('温馨提示'),
        content: Text('确定要删除所选食材吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              '取消',
              style: TextStyle(color: CustomColors.textGrayColor()),
            ),
          ),
          TextButton(
            onPressed: () {
              _selectedList.clear();
              _cookingName.value = "";

              Get.back();
            },
            child: Text(
              '确定',
              style: TextStyle(color: CustomColors.themeColor),
            ),
          ),
        ],
      ),
    );
  }

  _customConfigCook() {
    String material_ids =
        _selectedList.map((val) => val.id.toString()).join(', ');

    Map<String, dynamic>? arguments = {
      'methodName': 'SearchMix',
      'version': '4.3.2',
      'material_ids': material_ids,
    };

    // 路由跳转传值
    Get.toNamed('/cookConfig', arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('tab_cook_title'.tr),
          backgroundColor: CustomColors.themeColor,
          actions: [
            SizedBox(width: 15),
            Obx(() => Visibility(
                visible: _cookingName.value.length > 0,
                child: IconButton(
                    icon: Image.asset('assets/images/delete_white.png',
                        width: 25, height: 25),
                    onPressed: () {
                      _showDeleteAlert();
                    })))
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              width: width,
              height: 120,
              color: CustomColors.bg3Color(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 控制水平方向上的居中
                children: [
                  Text(
                    "请选择您要烹饪的食材吧~",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Obx(() => Text("当前已选食材：" + _cookingName.string,
                      style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColors.textGrayColor()))),
                  SizedBox(height: 10),
                  GFButton(
                      child: Text("开始烹饪"),
                      enableFeedback: true,
                      color: CustomColors.themeColor,
                      shape: GFButtonShape.pills,
                      type: GFButtonType.outline2x,
                      onPressed: () {
                        if (_selectedList.length == 0) {
                          ToastUtils.showSnackbar("温馨提示", "您还未选择食材");
                          return;
                        }

                        // 去配菜
                        _customConfigCook();
                      }),
                  SizedBox(width: 50),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length, //总共的分组
                itemBuilder: (context, groupIndex) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            width: width,
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              dataList[groupIndex].text ?? "--",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )),
                      ),
                      GridView.builder(
                        shrinkWrap: true, // 使得 GridView 自适应内容的高度
                        physics:
                            NeverScrollableScrollPhysics(), // 防止 GridView 滚动
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 1.0,
                        ),
                        itemCount:
                            dataList[groupIndex].data!.length, // 对应分组里的数据
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: CookHomeCell(
                                model: dataList[groupIndex].data![index]),
                            onTap: () {
                              _handlerSelectFood(
                                  dataList[groupIndex].data![index]);
                            },
                          );
                        },
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        )));
  }
}
