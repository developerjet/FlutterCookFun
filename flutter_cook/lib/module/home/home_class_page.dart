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
    final items = foodData.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(foodData.text ?? '—'),
      ),
      body: (items == null || items.isEmpty)
          ? EmptyState.empty(
              title: 'no_data'.tr,
              description: 'no_ingredients'.tr,
            )
          : ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _classConfigCook(item),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context)
                              .dividerColor
                              .withValues(alpha: 0.45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            AppNetworkImage(
                              url: item.image,
                              width: 104,
                              height: 76,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                item.text ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right,
                              size: 22,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.55),
                            ),
                          ],
                        ),
                      ),
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
