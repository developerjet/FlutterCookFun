import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:flutter_cook/module/setting/widgets/setting_widgets.dart';
import 'package:get/get.dart';

/// 独立的主题设置页面。
class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingController>();
    return Scaffold(
      appBar: AppNavBar(title: 'change_theme'.tr),
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
              const SizedBox(height: 18),
              SettingChoiceCard(
                key: const ValueKey('setting_theme_light'),
                title: 'light_theme'.tr,
                subtitle: 'light_theme_description'.tr,
                icon: Icons.light_mode_rounded,
                selected: controller.selectedTheme.value == 0,
                onTap: () => controller.changeTheme(0),
              ),
              const SizedBox(height: 12),
              SettingChoiceCard(
                key: const ValueKey('setting_theme_dark'),
                title: 'dark_theme'.tr,
                subtitle: 'dark_theme_description'.tr,
                icon: Icons.dark_mode_rounded,
                selected: controller.selectedTheme.value == 1,
                onTap: () => controller.changeTheme(1),
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
