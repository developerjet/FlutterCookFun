import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

class FoodClassPage extends StatelessWidget {
  const FoodClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = Get.arguments;
    final HomeFoodListData foodData =
        arguments is HomeFoodListData ? arguments : HomeFoodListData();

    return Scaffold(
      appBar: AppBar(
        title: Text(foodData.text ?? '—'),
      ),
      body: (foodData.data?.isEmpty ?? true)
          ? EmptyState.empty(title: 'no_data'.tr, description: 'no_ingredients'.tr)
          : ListView.builder(
              itemCount: foodData.data!.length,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemBuilder: (context, index) {
                final item = foodData.data![index];
                return InkWell(
            onTap: () => _classConfigCook(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 110,
                      height: 80,
                      child: AppNetworkImage(url: item.image),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.text ?? '',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right,
                      size: 22,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _classConfigCook(FoodSubData data) {
    Get.toNamed(RouteNames.cookConfig, arguments: {
      'methodName': 'CategorySearch',
      'version': '4.3.2',
      'cat_id': data.id,
      'type': data.type,
    });
  }
}
