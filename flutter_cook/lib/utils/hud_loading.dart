import 'package:flutter_easyloading/flutter_easyloading.dart';

class HudLoading {
  static void show(String? text) {
    EasyLoading.show(status: text);
  }

  static void showSuccess(String text) {
    EasyLoading.showSuccess(text);
  }

  static void showError(String text) {
    EasyLoading.showError(text);
  }

  static void showProgress(String? text) {
    EasyLoading.showProgress(0.3, status: text);
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
