import 'dart:ui';

import 'package:ecommerce_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });

  testWidgets(
    'Golden - products list',
    (tester) async {
      final robot = Robot(tester);
      final currentSize = sizeVariant.currentValue!;

      await robot.golden.setSurfaceSize(currentSize);
      await robot.golden.loadRobotoFont();
      await robot.golden.loadMaterialIconFont();
      await robot.pumpMyApp();
      await robot.golden.precacheImages();
      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('products_list_${currentSize.width.toInt()}x${currentSize.height.toInt()}.png'),
      );
    },
    variant: sizeVariant,
    tags: ['golden'],
  );
}
