import 'package:flutter_test/flutter_test.dart';

import '../test/src/robot.dart';

void main() {
  setUpAll(() => WidgetController.hitTestWarningShouldBeFatal = true);
  testWidgets(
    'Full purchase flow',
    (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyAppWithFakes();
        await r.fullPurchaseFlow();
      });
    },
    skip: true,
  );
}
