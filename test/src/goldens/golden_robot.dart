import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart';

class GoldenRobot {
  const GoldenRobot(this.tester);

  final WidgetTester tester;

  Future<void> loadMaterialIconFont() async {
    const fs = LocalFileSystem();
    const platform = LocalPlatform();
    final flutterRoot = fs.directory(platform.environment['FLUTTER_ROOT']);

    final iconFont = flutterRoot.childFile(
      fs.path.join(
        'bin',
        'cache',
        'artifacts',
        'material_fonts',
        'MaterialIcons-Regular.otf',
      ),
    );

    final bytes = Future<ByteData>.value(iconFont.readAsBytesSync().buffer.asByteData());

    final fontLoader = FontLoader('MaterialIcons')..addFont(bytes);
    await fontLoader.load();
  }

  Future<void> loadRobotoFont() async {
    final font = rootBundle.load('assets/fonts/Roboto-Regular.ttf');

    final fontLoader = FontLoader('Roboto')..addFont(font);
    await fontLoader.load();
  }

  Future<void> precacheImages() async {
    final finder = find.byType(Image);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.runAsync(() async {
        for (var match in matches) {
          final image = match.widget as Image;
          await precacheImage(image.image, match);
        }
      });
    }
    await tester.pumpAndSettle();
  }

  Future<void> setSurfaceSize(Size size) async {
    await tester.binding.setSurfaceSize(size);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
  }
}
