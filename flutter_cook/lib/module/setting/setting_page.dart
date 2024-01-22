import 'package:flutter/material.dart';
import 'package:flutter_cook/binding/controller/bindController.dart';
import 'package:flutter_cook/utils/language/manager.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  /// 所选主题
  late int selectedTheme = 0;

  /// 所选语言
  late int selectedLanguage = 0;

  late RxList<String> items = ['change_theme'.tr, 'setting_language'.tr].obs;

  // 实例化控制器
  GetxDataController dataController = Get.put(GetxDataController());

  @override
  void initState() {
    super.initState();

    _fetchSettingData();
  }

  Future<void> _fetchSettingData() async {
    selectedTheme = await ThemeManager.fetchLastTheme() ?? 0;
    selectedLanguage = await LanguageManager.fetchLastLanguage() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setting_title'.tr),
        backgroundColor: ThemeManager.themeColor,
      ),
      body: SafeArea(
          child: ListView.builder(
        itemExtent: 60,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Obx(() => Text(items[index])),
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
                color: ThemeManager.lineBoardColor(),
              ), // 分割线
            ],
          );
        },
        itemCount: items.length, // 替换为你实际的项目数量
      )),
    );
  }

  _settingTheme() {
    Get.bottomSheet(Container(
      color: ThemeManager.bottomSheetColor(),
      height: 200,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text('change_theme'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: ThemeManager.textMainColor())),
          ),
          ListTile(
            leading: Icon(Icons.wb_sunny_outlined,
                color: ThemeManager.textMainColor()),
            title: Text('light_theme'.tr,
                style: TextStyle(color: ThemeManager.textMainColor())),
            trailing: Visibility(
                visible: selectedTheme == 0,
                child:
                    Icon(Icons.check_rounded, color: ThemeManager.themeColor)),
            onTap: () {
              setState(() {
                selectedTheme = 0;
              });

              ThemeManager.saveTheme(0);
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: ThemeManager.textMainColor()),
            title: Text('dark_theme'.tr,
                style: TextStyle(color: ThemeManager.textMainColor())),
            trailing: Visibility(
                visible: selectedTheme == 1,
                child:
                    Icon(Icons.check_rounded, color: ThemeManager.themeColor)),
            onTap: () {
              setState(() {
                selectedTheme = 1;
              });

              ThemeManager.saveTheme(1);
              Get.back();
            },
          ),
        ],
      ),
    ));
  }

  _settingLanguage() {
    Get.bottomSheet(Container(
      color: ThemeManager.bottomSheetColor(),
      height: 200,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text('setting_language'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: ThemeManager.textMainColor())),
          ),
          ListTile(
            title: Text('language_zh'.tr,
                style: TextStyle(color: ThemeManager.textMainColor())),
            trailing: Visibility(
                visible: selectedLanguage == 0,
                child:
                    Icon(Icons.check_rounded, color: ThemeManager.themeColor)),
            onTap: () {
              //切换中文
              LanguageManager.saveLanguage(0);
              Get.back();

              setState(() {
                selectedLanguage = 0;
                items.value = ['change_theme'.tr, 'setting_language'.tr];
              });

              dataController.refreshSettings();
            },
          ),
          ListTile(
            title: Text('language_en'.tr,
                style: TextStyle(color: ThemeManager.textMainColor())),
            trailing: Visibility(
                visible: selectedLanguage == 1,
                child:
                    Icon(Icons.check_rounded, color: ThemeManager.themeColor)),
            onTap: () {
              //切换英文
              LanguageManager.saveLanguage(1);
              Get.back();

              setState(() {
                selectedLanguage = 1;
                items.value = ['change_theme'.tr, 'setting_language'.tr];
              });

              dataController.refreshSettings();
            },
          ), // 添加分割线
        ],
      ),
    ));
  }
}
