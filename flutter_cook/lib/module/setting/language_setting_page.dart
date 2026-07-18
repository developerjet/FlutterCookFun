import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:flutter_cook/module/setting/widgets/setting_widgets.dart';
import 'package:get/get.dart';

/// 独立的界面语言设置页面。
class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingController>();
    return Scaffold(
      appBar: AppNavBar(title: 'setting_language'.tr),
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
                key: const ValueKey('setting_language_zh'),
                title: 'language_zh'.tr,
                subtitle: 'language_zh_description'.tr,
                icon: Icons.translate_rounded,
                selected: controller.selectedLanguage.value == 0,
                onTap: () => controller.changeLanguage(0),
              ),
              const SizedBox(height: 12),
              SettingChoiceCard(
                key: const ValueKey('setting_language_en'),
                title: 'language_en'.tr,
                subtitle: 'language_en_description'.tr,
                icon: Icons.language_rounded,
                selected: controller.selectedLanguage.value == 1,
                onTap: () => controller.changeLanguage(1),
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
