import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// toast弹框封装
class ToastUtils {
  
  static void showShortToast(String message) {
    _showToast(message, Toast.LENGTH_SHORT);
  }

  static void showLongToast(String message) {
    _showToast(message, Toast.LENGTH_LONG);
  }

  static void _showToast(String message, Toast toastLength) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showColoredToast(
      String message, Color backgroundColor, Color textColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  static void showCustomDurationToast(String message, int durationInSeconds) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: durationInSeconds,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showSnackbar(String title, String message) {
    Get.snackbar(title, message, duration: Duration(seconds: 2));
  }
}
