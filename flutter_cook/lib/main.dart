import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import './routers/routers.dart';
import 'utils/language/language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        defaultGlobalState: true,
        debugShowCheckedModeBanner: false,
        title: "Cook Fun",
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeManager.lightTheme,
        darkTheme: ThemeManager.darkTheme,
        themeMode: ThemeManager.currentThemeMode.value,
        initialRoute: "/",
        getPages: AppRouter.routers,
        builder: EasyLoading.init(),
      ),
    );
  }
}
