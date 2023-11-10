import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets(
    'sign in and sign out flow',
    (tester) async {
      final robot = Robot(tester);

      await robot.pumpMyApp();
      robot.products.expectFindAllProductCards();

      await robot.openPopupMenu();
      await robot.auth.openEmailPasswordSignInScreen();
      await robot.auth.tapOnNeedAnAccountButton();
      await robot.auth.enterAndSubmitEmailAndPassword();

      robot.products.expectFindAllProductCards();

      await robot.openPopupMenu();
      await robot.auth.openAccountScreen();
      await robot.auth.tapLogoutButton();
      await robot.auth.tapDialogLogoutButton();

      robot.products.expectFindAllProductCards();
    },
  );
}
