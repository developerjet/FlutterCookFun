import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import './routers/routers.dart';
import './binding/binding.dart';
import 'utils/language/language.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultGlobalState: true,
      title: "Cook Fun",
      translations: Messages(), // 你的翻译
      locale: const Locale('zh', 'CN'), // 默认中文
      fallbackLocale: const Locale('en', 'US'), // 回调语言选项
      initialBinding: AllControllerBinding(), //全部绑定Getx BindingController
      theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primarySwatch: ThemeManager.createMaterialColor(Color(0XFF00CC99)),
          fontFamily: "Exo",
          appBarTheme: const AppBarTheme(
            backgroundColor: ThemeManager.themeColor,
            centerTitle: true,
          )),
      darkTheme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primarySwatch: ThemeManager.createMaterialColor(Color(0XFF00CC99)),
          fontFamily: "Exo",
          appBarTheme: const AppBarTheme(
            backgroundColor: ThemeManager.themeColor,
            centerTitle: true,
          )),
      initialRoute: "/", // 配置初始路由
      getPages: AppRouter.routers,
      builder: EasyLoading.init(), //加载Loading
    );
  }
}
