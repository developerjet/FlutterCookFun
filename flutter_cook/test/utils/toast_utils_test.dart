import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ToastUtils configure applies compact toast style', () {
    ToastUtils.configure();

    expect(EasyLoading.instance.loadingStyle, EasyLoadingStyle.custom);
    expect(
      EasyLoading.instance.contentPadding,
      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
    );
    expect(EasyLoading.instance.textPadding, EdgeInsets.zero);
    expect(EasyLoading.instance.radius, 10);
    expect(EasyLoading.instance.fontSize, 14);
  });
}
