import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cook/binding/binding.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import './routers/routers.dart';
import 'utils/language/language.dart';
import 'utils/language/manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 统一依赖注入
  AppBindings().dependencies();

  // 初始化主题
  await Get.find<ThemeManager>().initialize();
  final initialLocale = await LanguageManager.fetchLastLocale();
  ToastUtils.configure();

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final themeManager = Get.find<ThemeManager>();
    final easyLoadingBuilder = EasyLoading.init();
    return Obx(
      () => GetMaterialApp(
        defaultGlobalState: true,
        debugShowCheckedModeBanner: false,
        title: "Cook Fun",
        translations: Messages(),
        locale: Get.locale ?? initialLocale,
        fallbackLocale: const Locale('en', 'US'),
        theme: themeManager.lightTheme,
        darkTheme: themeManager.darkTheme,
        themeMode: themeManager.currentThemeMode.value,
        initialRoute: "/",
        getPages: AppRouter.routers,
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            key: const ValueKey('app_system_ui_style'),
            value: CookTheme.systemUiOverlayStyle(
              Theme.of(context).brightness,
            ),
            child: easyLoadingBuilder(context, child),
          );
        },
      ),
    );
  }
}
