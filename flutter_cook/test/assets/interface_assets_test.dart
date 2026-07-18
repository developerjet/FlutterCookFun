import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const assetPaths = <String>[
    'assets/images/app_logo.png',
    'assets/images/tab_home.png',
    'assets/images/tab_home_active.png',
    'assets/images/tab_cook.png',
    'assets/images/tab_cook_active.png',
    'assets/images/tab_recipe.png',
    'assets/images/tab_recipe_active.png',
    'assets/images/tab_mine.png',
    'assets/images/tab_mine_active.png',
    'assets/images/icon_search.png',
    'assets/images/icon_delete.png',
    'assets/images/icon_arrow_right.png',
    'assets/images/icon_check.png',
    'assets/images/icon_uncheck.png',
    'assets/images/icon_favorite.png',
    'assets/images/icon_favorite_active.png',
    'assets/images/icon_video_play.png',
    'assets/images/icon_refresh.png',
    'assets/images/icon_settings.png',
    'assets/images/icon_share.png',
    'assets/images/icon_close.png',
    'assets/images/icon_smart.png',
    'assets/images/bg_banner_placeholder.png',
    'assets/images/bg_image_placeholder.png',
  ];

  test('assets images directory only contains active app images', () {
    final files = Directory('assets/images')
        .listSync()
        .whereType<File>()
        .map((file) => file.path.replaceAll('\\', '/'))
        .toSet();

    expect(files, assetPaths.toSet());
    expect(
      Directory('assets/images').listSync().whereType<Directory>(),
      isEmpty,
    );
  });

  test('Git 索引不得残留 Flutter 倍率资源目录', () {
    final result = Process.runSync(
      'git',
      const ['ls-files', 'assets/images/2.0x', 'assets/images/3.0x'],
    );

    expect(result.exitCode, 0);
    expect((result.stdout as String).trim(), isEmpty);
  });

  test('资源生成器会主动清理旧倍率目录', () {
    final outputDirectory = Directory.systemTemp.createTempSync(
      'cookfun-assets-',
    );
    addTearDown(() => outputDirectory.deleteSync(recursive: true));

    File('assets/images/app_logo.png').copySync(
      '${outputDirectory.path}/app_logo.png',
    );
    Directory('${outputDirectory.path}/2.0x').createSync();
    Directory('${outputDirectory.path}/3.0x').createSync();

    final result = Process.runSync(
      'python3',
      [
        'scripts/generate_interface_assets.py',
        '--output-dir',
        outputDirectory.path,
      ],
    );

    expect(result.exitCode, 0, reason: result.stderr as String);
    expect(Directory('${outputDirectory.path}/2.0x').existsSync(), isFalse);
    expect(Directory('${outputDirectory.path}/3.0x').existsSync(), isFalse);
  });

  for (final assetPath in assetPaths) {
    test('loads $assetPath', () async {
      final data = await rootBundle.load(assetPath);

      expect(data.lengthInBytes, greaterThan(0));
    });
  }

  const expectedAssetSizes = <String, List<int>>{
    'assets/images/app_logo.png': [88, 88],
    'assets/images/tab_home.png': [96, 96],
    'assets/images/tab_home_active.png': [96, 96],
    'assets/images/tab_cook.png': [96, 96],
    'assets/images/tab_cook_active.png': [96, 96],
    'assets/images/tab_recipe.png': [96, 96],
    'assets/images/tab_recipe_active.png': [96, 96],
    'assets/images/tab_mine.png': [96, 96],
    'assets/images/tab_mine_active.png': [96, 96],
    'assets/images/icon_search.png': [96, 96],
    'assets/images/icon_delete.png': [96, 96],
    'assets/images/icon_arrow_right.png': [96, 96],
    'assets/images/icon_check.png': [84, 84],
    'assets/images/icon_uncheck.png': [84, 84],
    'assets/images/icon_favorite.png': [108, 108],
    'assets/images/icon_favorite_active.png': [108, 108],
    'assets/images/icon_video_play.png': [360, 360],
    'assets/images/icon_refresh.png': [96, 96],
    'assets/images/icon_settings.png': [96, 96],
    'assets/images/icon_share.png': [96, 96],
    'assets/images/icon_close.png': [96, 96],
    'assets/images/icon_smart.png': [96, 96],
    'assets/images/bg_banner_placeholder.png': [1179, 804],
    'assets/images/bg_image_placeholder.png': [294, 294],
  };

  test('uses expected pixel dimensions', () async {
    for (final entry in expectedAssetSizes.entries) {
      final data = await rootBundle.load(entry.key);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();

      expect(frame.image.width, entry.value[0], reason: entry.key);
      expect(frame.image.height, entry.value[1], reason: entry.key);

      frame.image.dispose();
      codec.dispose();
    }
  });

  test('图片资源命名不得包含设计稿版本前缀', () {
    final versionedAssets = Directory('assets/images')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.uri.pathSegments.last.startsWith('v6_'));

    expect(versionedAssets, isEmpty);
  });

  test('tab icons keep transparent canvas and sufficient visual weight',
      () async {
    const tabIconPaths = <String>[
      'assets/images/tab_home.png',
      'assets/images/tab_home_active.png',
      'assets/images/tab_cook.png',
      'assets/images/tab_cook_active.png',
      'assets/images/tab_recipe.png',
      'assets/images/tab_recipe_active.png',
      'assets/images/tab_mine.png',
      'assets/images/tab_mine_active.png',
    ];

    for (final assetPath in tabIconPaths) {
      final pixels = await _decodeAssetPixels(assetPath);

      expect(pixels.width, 96, reason: assetPath);
      expect(pixels.height, 96, reason: assetPath);
      expect(pixels.alphaAt(0, 0), 0, reason: assetPath);
      expect(pixels.alphaAt(95, 0), 0, reason: assetPath);
      expect(pixels.alphaAt(0, 95), 0, reason: assetPath);
      expect(pixels.alphaAt(95, 95), 0, reason: assetPath);

      final bounds = pixels.alphaBounds();
      expect(bounds, isNotNull, reason: assetPath);
      expect(bounds!.width, greaterThanOrEqualTo(66), reason: assetPath);
      expect(bounds.height, greaterThanOrEqualTo(72), reason: assetPath);
    }
  });

  test('操作类线性图标使用可审查的中性源色而不是纯白遮罩', () async {
    const actionIconPaths = <String>[
      'assets/images/icon_search.png',
      'assets/images/icon_delete.png',
      'assets/images/icon_arrow_right.png',
      'assets/images/icon_refresh.png',
      'assets/images/icon_settings.png',
      'assets/images/icon_share.png',
      'assets/images/icon_close.png',
    ];

    for (final assetPath in actionIconPaths) {
      final pixels = await _decodeAssetPixels(assetPath);
      final visibleColors = pixels.visibleRgbColors();

      expect(visibleColors, isNotEmpty, reason: assetPath);
      expect(
        visibleColors.every((color) => color.toARGB32() == 0xFFFFFFFF),
        isFalse,
        reason: '$assetPath 不应依赖纯白遮罩才能识别图标',
      );
    }
  });

  test('删除图标保持标准光学边界和透明安全区', () async {
    final pixels = await _decodeAssetPixels('assets/images/icon_delete.png');
    final bounds = pixels.alphaBounds();

    expect(bounds, isNotNull);
    expect(bounds!.width, greaterThanOrEqualTo(60));
    expect(bounds.height, greaterThanOrEqualTo(66));
    expect(pixels.alphaAt(0, 0), 0);
    expect(pixels.alphaAt(95, 95), 0);
  });
}

class _DecodedPixels {
  final int width;
  final int height;
  final ByteData data;

  const _DecodedPixels({
    required this.width,
    required this.height,
    required this.data,
  });

  int alphaAt(int x, int y) {
    final offset = (y * width + x) * 4;
    return data.getUint8(offset + 3);
  }

  Rect? alphaBounds() {
    var minX = width;
    var minY = height;
    var maxX = -1;
    var maxY = -1;

    for (var y = 0; y < height; y += 1) {
      for (var x = 0; x < width; x += 1) {
        if (alphaAt(x, y) == 0) {
          continue;
        }

        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }

    if (maxX < 0 || maxY < 0) {
      return null;
    }

    return Rect.fromLTRB(
      minX.toDouble(),
      minY.toDouble(),
      (maxX + 1).toDouble(),
      (maxY + 1).toDouble(),
    );
  }

  Set<Color> visibleRgbColors() {
    final colors = <Color>{};
    for (var y = 0; y < height; y += 1) {
      for (var x = 0; x < width; x += 1) {
        final offset = (y * width + x) * 4;
        final alpha = data.getUint8(offset + 3);
        if (alpha == 0) {
          continue;
        }
        colors.add(Color.fromARGB(
          255,
          data.getUint8(offset),
          data.getUint8(offset + 1),
          data.getUint8(offset + 2),
        ));
      }
    }
    return colors;
  }
}

Future<_DecodedPixels> _decodeAssetPixels(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  final image = frame.image;
  final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

  expect(byteData, isNotNull, reason: assetPath);

  final pixels = _DecodedPixels(
    width: image.width,
    height: image.height,
    data: byteData!,
  );
  image.dispose();
  codec.dispose();
  return pixels;
}
