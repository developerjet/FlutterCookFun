import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:flutter_cook/module/setting/widgets/setting_widgets.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

/// 设置入口页，只负责导航到独立的主题和语言设置页面。
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : Get.put(SettingController());

    return Scaffold(
      appBar: AppNavBar(title: 'setting_title'.tr),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(
              CookTokens.pagePadding,
              14,
              CookTokens.pagePadding,
              32,
            ),
            children: [
              if (controller.isLoading.value) ...[
                LinearProgressIndicator(
                  minHeight: 3,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
              ],
              const SizedBox(height: 18),
              SettingNavigationCard(
                key: const ValueKey('setting_theme_entry'),
                title: 'change_theme'.tr,
                subtitle: 'setting_theme_description'.tr,
                icon: Icons.contrast_rounded,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                onTap: () => Get.toNamed(RouteNames.themeSetting),
              ),
              const SizedBox(height: 12),
              SettingNavigationCard(
                key: const ValueKey('setting_language_entry'),
                title: 'setting_language'.tr,
                subtitle: 'setting_language_description'.tr,
                icon: Icons.translate_rounded,
                foregroundColor: Theme.of(context).colorScheme.tertiary,
                backgroundColor:
                    Theme.of(context).colorScheme.tertiaryContainer,
                onTap: () => Get.toNamed(RouteNames.languageSetting),
              ),
              if (controller.errorMessage.value != null) ...[
                const SizedBox(height: 18),
                SettingErrorView(message: controller.errorMessage.value!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
