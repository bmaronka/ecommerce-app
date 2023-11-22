import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets(
    'sign in and sign out flow',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        robot.products.expectProductsListLoaded();

        await robot.openPopupMenu();
        await robot.auth.openEmailPasswordSignInScreen();
        await robot.auth.tapOnNeedAnAccountButton();
        await robot.auth.enterAndSubmitEmailAndPassword();

        robot.products.expectProductsListLoaded();

        await robot.openPopupMenu();
        await robot.auth.openAccountScreen();
        await robot.auth.tapLogoutButton();
        await robot.auth.tapDialogLogoutButtonAndSettle();

        robot.products.expectProductsListLoaded();
      });
    },
  );
}
