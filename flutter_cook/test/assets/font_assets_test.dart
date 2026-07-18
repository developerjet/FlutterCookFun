import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Exo 字体必须作为全局品牌字体打包', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final fontDirectory = Directory('assets/fonts');
    final bundledFonts = fontDirectory.existsSync()
        ? fontDirectory
            .listSync()
            .whereType<File>()
            .where((file) =>
                file.path.endsWith('.ttf') || file.path.endsWith('.otf'))
            .toList()
        : const <File>[];

    expect(pubspec, contains('family: Exo'));
    expect(pubspec, contains('assets/fonts/Exo-Regular.ttf'));
    expect(pubspec, contains('assets/fonts/Exo-Medium.ttf'));
    expect(pubspec, contains('assets/fonts/Exo-Bold.ttf'));
    expect(
        bundledFonts.map((file) => file.path),
        containsAll([
          'assets/fonts/Exo-Regular.ttf',
          'assets/fonts/Exo-Medium.ttf',
          'assets/fonts/Exo-Bold.ttf',
        ]));
  });
}
