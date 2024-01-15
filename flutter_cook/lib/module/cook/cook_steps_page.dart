import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_cell.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_header.dart';
import 'package:flutter_cook/base/imageViewer.dart';
import 'package:flutter_cook/module/home/controller/foodClassController.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/utils/hudLoading.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/utils/sqlite/db_manager.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../cook/views/cook_config_cell.dart';

class CookStepsPage extends StatefulWidget {
  const CookStepsPage({Key? key}) : super(key: key);

  @override
  _CookStepsPageState createState() => _CookStepsPageState();
}

class _CookStepsPageState extends State<CookStepsPage> {
  late CookStepDataModel stepsModel;
  late List<StepLitsModel> dataList = [];
  late List<String> imageUrls = [];

  /// 实例化控制器
  FoodDataController dataController = Get.put(FoodDataController());

  /// 是否收藏
  RxBool _isFavorite = false.obs;

  @override
  void initState() {
    // 初始化
    stepsModel = CookStepDataModel.fromJson({});

    super.initState();

    HudLoading.show('Loading...');

    _fetchCookingSteps();
  }

  @override
  void dispose() {
    HudLoading.dismiss();
    super.dispose();
  }

  // 获取做菜步骤
  Future<void> _fetchCookingSteps() async {
    Map<String, dynamic>? params = {
      'methodName': 'DishesView',
      'version': '4.3.2',
      'dishes_id': Get.arguments['dishes_id'],
    };

    final response = await DioClient.get('', queryParameters: params);
    dynamic jsonData = response.data['data'];
    if (jsonData!.isEmpty == true) {
      HudLoading.dismiss();
      HudLoading.showError("暂无数据~");
      return;
    }

    stepsModel = CookStepDataModel.fromJson(jsonData);

    HudLoading.dismiss();
    _queryConfigFavorite();

    if (stepsModel.step!.length > 0) {
      for (var model in stepsModel.step!) {
        imageUrls.add(model.dishesStepImage ?? "");
      }

      setState(() {
        dataList = stepsModel.step!;
      });
    }
  }

  // 查询是否已收藏
  _queryConfigFavorite() async {
    String dishesId = Get.arguments['dishes_id'];

    List<CookConfigListModel>? results = await DBManager().find(dishesId);

    if (results != null && results.length > 0) {
      _isFavorite.value = true;
    } else {
      _isFavorite.value = false;
    }
  }

  // 收藏
  _beginFavoriteCook(CookStepDataModel model) async {
    var cookConfig = CookConfigListModel();
    cookConfig.dishesId = model.dashesId;
    cookConfig.image = model.image;
    cookConfig.title = model.dashesName;
    cookConfig.hardLevel = model.hardLevel;
    cookConfig.taste = model.taste;
    cookConfig.cookingTime = model.cookingTime;
    cookConfig.description = model.materialDesc;

    int result = await DBManager().saveData(cookConfig);

    if (result > 0) {
      HudLoading.showSuccess("收藏成功");
      _isFavorite.value = true;

      if (Get.arguments['pushPage'] == "myFavorites") {
        dataController.refreshFavorite();
      }
    } else {
      HudLoading.showError("操作失败");
    }
  }

  // 取消收藏
  _clearFavoriteCook(CookStepDataModel model) async {
    int result = await DBManager().delete(model.dashesId!);

    if (result > 0) {
      HudLoading.showSuccess("已取消收藏");
      _isFavorite.value = false;

      if (Get.arguments['pushPage'] == "myFavorites") {
        dataController.refreshFavorite();
      }
    } else {
      HudLoading.showError("操作失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cook_steps_title'.tr),
        backgroundColor: ThemeManager.themeColor,
        actions: [
          IconButton(
            icon: Obx(() => Icon(_isFavorite.value == true
                ? Icons.favorite_outlined
                : Icons.favorite_border)),
            onPressed: () {
              if (_isFavorite.value) {
                _clearFavoriteCook(stepsModel);
              } else {
                _beginFavoriteCook(stepsModel);
              }
            },
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 顶部Banner
          SliverToBoxAdapter(
            child: Container(
                height: 420,
                child: Visibility(
                    visible: dataList.length > 0,
                    child: CookStepsHeader(
                      model: stepsModel,
                      onTap: () {
                        _showPlaySheetBottom();
                      },
                    ))),
          ),
          // 列表数据
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return InkWell(
                  child: CookStepsCell(model: dataList[index]),
                  onTap: () {
                    Get.toNamed("/imageViewer",
                        arguments: {'imageUrls': imageUrls});
                  },
                );
              },
              childCount: dataList.length,
            ),
          ),
        ],
      ),
    );
  }

  _beginPlayVideo(int index) {
    final List videoList = [stepsModel.materialVideo, stepsModel.processVideo];
    Get.toNamed("player", arguments: {'url': videoList[index]});
  }

  _showPlaySheetBottom() {
    Get.bottomSheet(Container(
      color: ThemeManager.bottomSheetColor(),
      height: 200,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text("选择视频",
                textAlign: TextAlign.center,
                style: TextStyle(color: ThemeManager.textMainColor())),
          ),
          ListTile(
            leading: Icon(Icons.video_call_sharp,
                color: ThemeManager.textMainColor()),
            title: Text("视频1",
                style: TextStyle(color: ThemeManager.textMainColor())),
            onTap: () {
              Get.back();
              _beginPlayVideo(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.video_call_sharp,
                color: ThemeManager.textMainColor()),
            title: Text("视频2",
                style: TextStyle(color: ThemeManager.textMainColor())),
            onTap: () {
              Get.back();
              _beginPlayVideo(1);
            },
          ),
        ],
      ),
    ));
  }
}
