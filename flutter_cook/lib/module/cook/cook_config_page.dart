import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_dialog.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/cook/cook_route_args.dart';
import 'package:flutter_cook/module/cook/controller/cook_config_controller.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/toast.dart';
import '../cook/views/cook_config_cell.dart';
import 'package:get/get.dart';

class CookConfigPage extends StatefulWidget {
  const CookConfigPage({super.key});

  @override
  State<CookConfigPage> createState() => _CookConfigPageState();
}

class _CookConfigPageState extends State<CookConfigPage> {
  final CookConfigController controller = Get.isRegistered<CookConfigController>()
      ? Get.find<CookConfigController>()
      : Get.put(CookConfigController());
  final EasyRefreshController _refreshController = EasyRefreshController();
  late final CookConfigArguments arguments;

  @override
  void initState() {
    super.initState();
    arguments = CookConfigArguments.fromMap(
        Get.arguments as Map<String, dynamic>?);
    controller.loadCookConfigData(arguments, refresh: true);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // 开始配菜
  Future<void> _fetchConfigCooking({bool refresh = false}) async {
    if (refresh) {
      await controller.loadCookConfigData(arguments, refresh: true);
      return;
    }

    final success = await controller.loadNextPage(arguments);
    if (!success) {
      ToastUtils.showShortToast('load_failed_try_again'.tr);
    }

    if (controller.cookConfigList.isEmpty &&
        controller.configErrorMessage.value == null) {
      _showConfigFailedAlert('recipe_selection_failed'.tr);
    }
  }

  _showConfigFailedAlert(String msg) {
    AppDialog.alert(
      context,
      title: 'warning_prompt'.tr,
      content: msg,
      actionText: 'confirm'.tr,
      onAction: () {
        Get.back(); // 关闭当前页面
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('recipe_count_title'.trArgs([controller.cookConfigList.length.toString()]))),
      ),
      body: Obx(() {
        if (!arguments.isValid) {
          return EmptyState.error(
            title: 'parameter_error'.tr,
            description: 'unable_find_recipes'.tr,
            onRetry: () {
              controller.loadCookConfigData(arguments, refresh: true);
            },
          );
        }

        if (controller.isLoading.value &&
            controller.cookConfigList.isEmpty) {
          return EmptyState.loading(
            title: 'loading'.tr,
            description: 'loading_recipes'.tr,
          );
        }

        if (controller.cookConfigList.isEmpty) {
          if (controller.configErrorMessage.value != null) {
            return EmptyState.error(
              title: 'load_failed'.tr,
              description: controller.configErrorMessage.value,
              onRetry: () {
                _fetchConfigCooking(refresh: true);
              },
            );
          }
          return EmptyState.empty(
            title: 'no_recipes'.tr,
            description: 'unable_find_recipes'.tr,
            onRefresh: () {
              _fetchConfigCooking(refresh: true);
            },
          );
        }

        return EasyRefresh(
          controller: _refreshController,
          onRefresh: () async {
            await controller.loadCookConfigData(arguments, refresh: true);
          },
          onLoad: () async {
            if (!controller.configHasMore.value) {
              ToastUtils.showShortToast('no_more_recipes'.tr);
              return;
            }
            await _fetchConfigCooking();
          },
          child: ListView.builder(
            itemCount: controller.cookConfigList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Column(
                  children: [
                    CookConfigCell(model: controller.cookConfigList[index]),
                    Divider(
                        height: 0.75, // 设置分割线的高度
                        color: Theme.of(context).dividerColor),
                  ],
                ),
                onTap: () {
                  Get.toNamed(RouteNames.cookSteps, arguments: {
                    'dishes_id': controller.cookConfigList[index].dishesId,
                    'pushPage': 'cookConfig'
                  });
                },
              );
            },
          ),
        );
      }),
    );
  }
}
