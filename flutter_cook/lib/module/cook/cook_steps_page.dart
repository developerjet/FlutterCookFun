import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_cell.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_header.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:get/get.dart';

class CookStepsPage extends StatefulWidget {
  const CookStepsPage({Key? key}) : super(key: key);

  @override
  _CookStepsPageState createState() => _CookStepsPageState();
}

class _CookStepsPageState extends State<CookStepsPage> {
  late CookStepDataModel stepsModel;
  late List<StepLitsModel> dataList = [];

  @override
  void initState() {
    // 初始化
    stepsModel = CookStepDataModel.fromJson({});

    super.initState();

    _fetchCookingSteps();
  }

  // 获取做菜步骤
  Future<void> _fetchCookingSteps() async {
    Map<String, dynamic>? params = {
      'methodName': 'DishesView',
      'version': '4.3.2',
      'dishes_id': Get.arguments['dishes_id'],
    };

    final response = await DioClient.get('', queryParameters: params);

    stepsModel = CookStepDataModel.fromJson(response.data['data']);

    if (stepsModel.step!.length > 0) {
      setState(() {
        dataList = stepsModel.step!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("做菜步骤"),
        backgroundColor: CustomColors.themeColor,
      ),
      body: CustomScrollView(
        slivers: [
          // 顶部Banner
          SliverToBoxAdapter(
            child: Container(
                height: 420,
                child: CookStepsHeader(
                  model: stepsModel,
                  onTap: () {
                    _beginPlayVideo();
                  },
                )),
          ),
          // 列表数据
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return CookStepsCell(model: dataList[index]);
              },
              childCount: dataList.length,
            ),
          ),
        ],
      ),
    );
  }

  _beginPlayVideo() {
    if (stepsModel.materialVideo!.length > 0 &&
        stepsModel.processVideo!.length > 0) {
      Map<String, dynamic>? arguments = {
        'materialVideo': stepsModel.materialVideo,
        'processVideo': stepsModel.processVideo
      };
      Get.toNamed("player", arguments: arguments);
    }
  }
}
