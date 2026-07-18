import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('网络图片切换时不得保留上一张图片帧', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            height: 90,
            child: AppNetworkImage(url: 'https://example.com/recipe.png'),
          ),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.gaplessPlayback, isFalse);
  });
}
