import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_bottom_sheet.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setting_title'.tr),
      ),
      body: SafeArea(
        child: Obx(
          () {
            return ListView.builder(
              itemExtent: 60,
              itemCount: controller.settingsItems.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(controller.settingsItems[index]),
                      trailing: Image.asset('assets/images/arrow_right.png',
                          width: 20, height: 18),
                      onTap: () {
                        if (index == 0) {
                          _settingTheme();
                        } else {
                          _settingLanguage();
                        }
                      },
                    ),
                    Divider(
                      height: 0.5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _settingTheme() {
    AppBottomSheet.show(context, children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Text('change_theme'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color)),
      ),
      AppSheetAction(
        icon: Icons.wb_sunny_outlined,
        label: 'light_theme'.tr,
        trailing: Obx(() => Visibility(
              visible: controller.selectedTheme.value == 0,
              child: Icon(Icons.check_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 22),
            )),
        onTap: () {
          controller.changeTheme(0);
          Navigator.pop(context);
        },
      ),
      AppSheetAction(
        icon: Icons.dark_mode,
        label: 'dark_theme'.tr,
        trailing: Obx(() => Visibility(
              visible: controller.selectedTheme.value == 1,
              child: Icon(Icons.check_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 22),
            )),
        onTap: () {
          controller.changeTheme(1);
          Navigator.pop(context);
        },
      ),
    ]);
  }

  void _settingLanguage() {
    AppBottomSheet.show(context, children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Text('setting_language'.tr,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      ),
      AppSheetAction(
        label: 'language_zh'.tr,
        trailing: Obx(() => Visibility(
              visible: controller.selectedLanguage.value == 0,
              child: Icon(Icons.check_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 22),
            )),
        onTap: () {
          controller.changeLanguage(0);
          Navigator.pop(context);
        },
      ),
      AppSheetAction(
        label: 'language_en'.tr,
        trailing: Obx(() => Visibility(
              visible: controller.selectedLanguage.value == 1,
              child: Icon(Icons.check_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 22),
            )),
        onTap: () {
          controller.changeLanguage(1);
          Navigator.pop(context);
        },
      ),
    ]);
  }
}
