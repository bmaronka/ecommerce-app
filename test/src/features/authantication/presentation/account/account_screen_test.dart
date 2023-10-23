import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';
import '../../auth_robot.dart';

void main() {
  late MockFakeAuthRepository mockFakeAuthRepository;

  setUp(() => mockFakeAuthRepository = MockFakeAuthRepository());

  testWidgets(
    'Cancel logout',
    (tester) async {
      final robot = AuthRobot(tester);

      await robot.pumpAccountScreen();
      await robot.tapLogoutButton();
      robot.expectLogoutDialogFound();
      await robot.tapCancelButton();
      robot.expectLogoutDialogNotFound();
    },
  );

  testWidgets(
    'Confirm logout, success',
    (tester) async {
      final robot = AuthRobot(tester);

      await tester.runAsync(() async {
        await robot.pumpAccountScreen();
        await robot.tapLogoutButton();
        robot.expectLogoutDialogFound();
        await robot.tapDialogLogoutButton();
      });

      robot.expectLogoutDialogNotFound();
      robot.expectErrorAlertNotFound();
    },
  );

  testWidgets(
    'Confirm logout, failure',
    (tester) async {
      final robot = AuthRobot(tester);
      final exception = Exception('Exception');

      when(mockFakeAuthRepository.signOut()).thenThrow(exception);
      when(mockFakeAuthRepository.authStateChanges()).thenAnswer(
        (_) => Stream.value(
          AppUser(
            uid: '123',
            email: 'test@test.com',
          ),
        ),
      );

      await tester.runAsync(() async {
        await robot.pumpAccountScreen(authRepository: mockFakeAuthRepository);
        await robot.tapLogoutButton();
        robot.expectLogoutDialogFound();
        await robot.tapDialogLogoutButton();
      });

      robot.expectLogoutDialogNotFound();
      robot.expectErrorAlertFound();
    },
  );

  testWidgets(
    'Confirm logout, loading state',
    (tester) async {
      final robot = AuthRobot(tester);

      when(mockFakeAuthRepository.signOut()).thenAnswer((_) => Future.delayed(const Duration(seconds: 1)));
      when(mockFakeAuthRepository.authStateChanges()).thenAnswer(
        (_) => Stream.value(
          AppUser(
            uid: '123',
            email: 'test@test.com',
          ),
        ),
      );

      await tester.runAsync(() async {
        await robot.pumpAccountScreen(authRepository: mockFakeAuthRepository);
        await robot.tapLogoutButton();
        robot.expectLogoutDialogFound();
        await robot.tapDialogLogoutButton();
      });

      robot.expectCircularProgressIndicator();
    },
  );
}
