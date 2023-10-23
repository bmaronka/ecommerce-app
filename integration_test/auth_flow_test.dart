import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'sign in and sign out flow',
    (tester) async {
      final robot = Robot(tester);

      await robot.pumpMyApp();
      robot.expectFindAllProductCards();
      await robot.openPopupMenu();
      await robot.auth.openEmailPasswordSignInScreen();
      await robot.auth.signInWithEmailAndPassword();
      robot.expectFindAllProductCards();
      await robot.openPopupMenu();
      await robot.auth.openAccountScreen();
      await robot.auth.tapLogoutButton();
      await robot.auth.tapDialogLogoutButton();
      robot.expectFindAllProductCards();
    },
  );
}
