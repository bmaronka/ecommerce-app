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
      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    },
  );

  test(
    'currentUser is non null after sign in',
    () async {
      await fakeAuthRepository.signInWithEmailAndPassword(email, password);

      addTearDown(fakeAuthRepository.dispose);

      expect(fakeAuthRepository.currentUser, user);
      expect(fakeAuthRepository.authStateChanges(), emits(user));
    },
  );

  test(
    'currentUser is non null after registration',
    () async {
      await fakeAuthRepository.createUserWithEmailAndPassword(email, password);

      addTearDown(fakeAuthRepository.dispose);

      expect(fakeAuthRepository.currentUser, user);
      expect(fakeAuthRepository.authStateChanges(), emits(user));
    },
  );

  test(
    'currentUser is null after sign out',
    () async {
      await fakeAuthRepository.signInWithEmailAndPassword(email, password);
      expect(fakeAuthRepository.currentUser, user);
      expect(fakeAuthRepository.authStateChanges(), emits(user));

      addTearDown(fakeAuthRepository.dispose);

      await fakeAuthRepository.signOut();
      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    },
  );

  test(
    'sign in after dispose throws an exception',
    () {
      fakeAuthRepository.dispose();
      expect(() => fakeAuthRepository.signInWithEmailAndPassword(email, password), throwsStateError);
    },
  );
}
