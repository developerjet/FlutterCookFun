import 'package:flutter/material.dart';
import 'package:flutter_cook/binding/binding.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import './routers/routers.dart';
import 'utils/language/language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 统一依赖注入
  AppBindings().dependencies();

  // 初始化主题
  await Get.find<ThemeManager>().initialize();
  ToastUtils.configure();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = Get.find<ThemeManager>();
    return Obx(
      () => GetMaterialApp(
        defaultGlobalState: true,
        debugShowCheckedModeBanner: false,
        title: "Cook Fun",
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        fallbackLocale: const Locale('en', 'US'),
        theme: themeManager.lightTheme,
        darkTheme: themeManager.darkTheme,
        themeMode: themeManager.currentThemeMode.value,
        initialRoute: "/",
        getPages: AppRouter.routers,
        builder: EasyLoading.init(),
      ),
    );
  }
}
