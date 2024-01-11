import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late List items = ['change_theme'.tr, 'setting_language'.tr];

  @override
  void initState() {
    super.initState();

    items = ['change_theme'.tr, 'setting_language'.tr];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settting_title'.tr),
        backgroundColor: CustomColors.themeColor,
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
                color: CustomColors.lineBoardColor(),
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
      color: CustomColors.bottomSheetColor(),
      height: 200,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text('change_theme'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColors.textMainColor())),
          ),
          ListTile(
            leading: Icon(Icons.wb_sunny_outlined,
                color: CustomColors.textMainColor()),
            title: Text('light_theme'.tr,
                style: TextStyle(color: CustomColors.textMainColor())),
            onTap: () {
              Get.changeTheme(ThemeData.light());
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: CustomColors.textMainColor()),
            title: Text('dark_theme'.tr,
                style: TextStyle(color: CustomColors.textMainColor())),
            onTap: () {
              Get.changeTheme(ThemeData.dark());
              Get.back();
            },
          ),
        ],
      ),
    ));
  }

  _settingLanguage() {
    Get.bottomSheet(Container(
      color: CustomColors.bottomSheetColor(),
      height: 200,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text('setting_language'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColors.textMainColor())),
          ),
          ListTile(
            title: Text('language_zh'.tr,
                style: TextStyle(color: CustomColors.textMainColor())),
            onTap: () {
              //切换中文
              Get.updateLocale(Locale('zh', 'CN'));
              Get.back();

              setState(() {
                items = ['change_theme'.tr, 'setting_language'.tr];
              });
            },
          ),
          ListTile(
            title: Text('language_en'.tr,
                style: TextStyle(color: CustomColors.textMainColor())),
            onTap: () {
              //切换英文
              Get.updateLocale(Locale('en', 'CN'));
              Get.back();

              setState(() {
                items = ['change_theme'.tr, 'setting_language'.tr];
              });
            },
          ), // 添加分割线
        ],
      ),
    ));
  }
}
