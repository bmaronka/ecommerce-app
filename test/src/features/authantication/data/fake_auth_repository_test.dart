import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;

  const email = 'test@test.com';
  const password = '123123123';
  final user = AppUser(
    uid: email.split('').reversed.join(),
    email: email,
  );

  setUp(() => fakeAuthRepository = FakeAuthRepository(addDelay: false));

  test(
    'currentUser is null',
    () {
      addTearDown(fakeAuthRepository.dispose);

      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    },
  );

  test(
    'sign in throws when user not found',
    () async {
      addTearDown(fakeAuthRepository.dispose);

      await expectLater(
        fakeAuthRepository.signInWithEmailAndPassword(email, password),
        throwsA(isA<Exception>()),
      );
      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    },
  );

  test(
    'currentUser is non null after registration',
    () async {
      addTearDown(fakeAuthRepository.dispose);

      await fakeAuthRepository.createUserWithEmailAndPassword(email, password);

      expect(fakeAuthRepository.currentUser, isA<AppUser>());
      expect(fakeAuthRepository.authStateChanges(), emits(user));
    },
  );

  test(
    'currentUser is null after sign out',
    () async {
      addTearDown(fakeAuthRepository.dispose);

      await fakeAuthRepository.createUserWithEmailAndPassword(
        email,
        password,
      );
      expect(fakeAuthRepository.currentUser, user);
      expect(fakeAuthRepository.authStateChanges(), emits(user));

      await fakeAuthRepository.signOut();
      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    },
  );

  test(
    'create user after dispose throws exception',
    () {
      fakeAuthRepository.dispose();
      expect(
        fakeAuthRepository.createUserWithEmailAndPassword(email, password),
        throwsStateError,
      );
    },
  );
}
