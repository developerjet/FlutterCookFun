import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

/// Toast 工具类 — 统一切换为 EasyLoading
class ToastUtils {
  static const Color _defaultBackgroundColor = Color(0xE61F2329);
  static const Color _defaultTextColor = Colors.white;
  static int _styleGeneration = 0;

  static void configure() {
    _applyToastStyle();
  }

  static void showShortToast(String message) {
    _showToast(message, duration: const Duration(seconds: 2));
  }

  static void showLongToast(String message) {
    _showToast(message, duration: const Duration(seconds: 4));
  }

  static void showColoredToast(
      String message, Color backgroundColor, Color textColor) {
    const duration = Duration(seconds: 2);
    _showToast(
      message,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  static void showCustomDurationToast(String message, int durationInSeconds) {
    _showToast(message, duration: Duration(seconds: durationInSeconds));
  }

  static void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      borderRadius: 10,
      snackPosition: SnackPosition.TOP,
      backgroundColor: _defaultBackgroundColor,
      colorText: _defaultTextColor,
      messageText: Text(
        message,
        style: const TextStyle(
          color: _defaultTextColor,
          fontSize: 14,
          height: 1.25,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: _defaultTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.25,
        ),
      ),
    );
  }

  static void _showToast(
    String message, {
    required Duration duration,
    Color backgroundColor = _defaultBackgroundColor,
    Color textColor = _defaultTextColor,
  }) {
    final generation = ++_styleGeneration;
    _applyToastStyle(backgroundColor: backgroundColor, textColor: textColor);
    EasyLoading.showToast(
      message,
      duration: duration,
      toastPosition: EasyLoadingToastPosition.center,
    );

    if (backgroundColor != _defaultBackgroundColor ||
        textColor != _defaultTextColor) {
      Future<void>.delayed(duration + const Duration(milliseconds: 240), () {
        if (generation == _styleGeneration) {
          _applyToastStyle();
        }
      });
    }
  }

  static void _applyToastStyle({
    Color backgroundColor = _defaultBackgroundColor,
    Color textColor = _defaultTextColor,
  }) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..toastPosition = EasyLoadingToastPosition.center
      ..animationStyle = EasyLoadingAnimationStyle.opacity
      ..animationDuration = const Duration(milliseconds: 160)
      ..displayDuration = const Duration(seconds: 2)
      ..radius = 10
      ..fontSize = 14
      ..textAlign = TextAlign.center
      ..contentPadding = const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 9,
      )
      ..textPadding = EdgeInsets.zero
      ..backgroundColor = backgroundColor
      ..textColor = textColor
      ..indicatorColor = textColor
      ..progressColor = textColor
      ..boxShadow = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.14),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ]
      ..maskType = EasyLoadingMaskType.none
      ..dismissOnTap = true
      ..userInteractions = true;
  }
}
