import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/views/cook_home_cell.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

class CookPage extends StatefulWidget {
  const CookPage({Key? key}) : super(key: key);

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  // 每次最大可选食材
  static const int _maxFoodCount = 5;

  final CookHomeController controller = Get.isRegistered<CookHomeController>()
      ? Get.find<CookHomeController>()
      : Get.put(CookHomeController());

  @override
  void initState() {
    super.initState();
  }

  void _handlerSelectFood(CookListDataModel model) {
    final selected = controller.toggleFoodSelection(model);
    if (!selected) {
      ToastUtils.showShortToast('toast_max_select'.trArgs([_maxFoodCount.toString()]));
    }
  }

  void _showDeleteAlert() {
    if (controller.selectedCookList.isEmpty) {
      ToastUtils.showSnackbar('warning_prompt'.tr, 'not_selected_ingredients'.tr);
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text('warning_prompt'.tr),
        content: Text('delete_selected_prompt'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).disabledColor),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.clearSelectedFoods();
              Get.back();
            },
            child: Text(
              'confirm'.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _customConfigCook() {
    if (controller.selectedCookList.isEmpty) {
      ToastUtils.showSnackbar('warning_prompt'.tr, 'not_selected_ingredients'.tr);
      return;
    }

    String materialIds =
        controller.selectedCookList.map((val) => val.id.toString()).join(', ');

    final arguments = {
      'methodName': 'SearchMix',
      'version': '4.3.2',
      'material_ids': materialIds,
    };

    // 路由跳转传值
    Get.toNamed(RouteNames.cookConfig, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('tab_cook_title'.tr),
          actions: [
            const SizedBox(width: 15),
            Obx(() => Visibility(
                visible: controller.selectedMaterialNames.value.isNotEmpty,
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
              color: Theme.of(context).cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 控制水平方向上的居中
                children: [
                  Text(
                    'select_ingredients_prompt'.tr,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Obx(() => Text(
                      '${'selected_ingredients'.tr}${controller.selectedMaterialNames.value}',
                      style: TextStyle(
                          fontSize: 13.0,
                          color: Theme.of(context).textTheme.bodyMedium?.color))),
                  const SizedBox(height: 10),
                  GFButton(
                      enableFeedback: true,
                      color: Theme.of(context).colorScheme.primary,
                      shape: GFButtonShape.pills,
                      type: GFButtonType.outline2x,
                      onPressed: () {
                        if (controller.selectedCookList.isEmpty) {
                          ToastUtils.showSnackbar('warning_prompt'.tr, 'not_selected_ingredients'.tr);
                          return;
                        }

                        // 去配菜
                        _customConfigCook();
                      },
                      child: Text('start_cooking'.tr)),
                  const SizedBox(width: 50),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final dataList = controller.cookHomeList;
                if (controller.isLoading.value) {
                  return EmptyState.loading(
                    title: 'loading'.tr,
                    description: 'loading_ingredients'.tr,
                  );
                }

                if (dataList.isEmpty) {
                  if (controller.errorMessage.value != null) {
                    return EmptyState.error(
                      title: 'load_failed'.tr,
                      description: controller.errorMessage.value,
                      onRetry: () => controller.loadCookHomeData(),
                    );
                  }
                  return EmptyState.empty(
                    title: 'no_ingredients'.tr,
                    description: 'unable_load_ingredients'.tr,
                    onRefresh: () => controller.loadCookHomeData(),
                  );
                }

                return ListView.builder(
                  itemCount: dataList.length, //总共的分组
                  itemBuilder: (context, groupIndex) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                dataList[groupIndex].text ?? "",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Exo"),
                              )),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.78,
                          ),
                          itemCount:
                              dataList[groupIndex].data!.length, // 对应分组里的数据
                          itemBuilder: (context, index) {
                            return GestureDetector(
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
                );
              }),
            ),
          ],
        )));
  }
}
