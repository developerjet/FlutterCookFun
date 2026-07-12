import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

/// Toast 工具类 — 统一切换为 EasyLoading
class ToastUtils {
  static void showShortToast(String message) {
    EasyLoading.showToast(message,
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void showLongToast(String message) {
    EasyLoading.showToast(message,
        duration: const Duration(seconds: 4),
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void showColoredToast(
      String message, Color backgroundColor, Color textColor) {
    EasyLoading.showToast(message,
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void showCustomDurationToast(String message, int durationInSeconds) {
    EasyLoading.showToast(message,
        duration: Duration(seconds: durationInSeconds),
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void showSnackbar(String title, String message) {
    Get.snackbar(title, message, duration: const Duration(seconds: 2));
  }
}
