import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  /// 主题模式
  late int lastTheme = 0;

  late List items = ['change_theme'.tr, 'setting_language'.tr];

  @override
  void initState() {
    super.initState();

    items = ['change_theme'.tr, 'setting_language'.tr];
    _fetchSettingData();
  }

  Future<void> _fetchSettingData() async {
    lastTheme = await ThemeManager.fetchLastTheme() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settting_title'.tr),
        backgroundColor: ThemeManager.themeColor,
      ),
      body: SafeArea(
          child: ListView.builder(
        itemExtent: 60,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(items[index]),
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
                visible: lastTheme == 0,
                child:
                    Icon(Icons.check_rounded, color: ThemeManager.themeColor)),
            onTap: () {
              ThemeManager.saveTheme(0);
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: ThemeManager.textMainColor()),
            title: Text('dark_theme'.tr,
                style: TextStyle(color: ThemeManager.textMainColor())),
            trailing: Visibility(
                visible: lastTheme == 1,
                child:
                    Icon(Icons.check_rounded, color: ThemeManager.themeColor)),
            onTap: () {
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
            onTap: () {
              setState(() {
                items = ['change_theme'.tr, 'setting_language'.tr];
              });

              //切换中文
              Get.updateLocale(Locale('zh', 'CN'));
              Get.back();
            },
          ),
          ListTile(
            title: Text('language_en'.tr,
                style: TextStyle(color: ThemeManager.textMainColor())),
            onTap: () {
              setState(() {
                items = ['change_theme'.tr, 'setting_language'.tr];
              });

              //切换英文
              Get.updateLocale(Locale('en', 'CN'));
              Get.back();
            },
          ), // 添加分割线
        ],
      ),
    ));
  }
}
