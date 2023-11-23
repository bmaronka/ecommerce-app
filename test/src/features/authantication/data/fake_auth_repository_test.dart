import 'package:ecommerce_app/src/exceptions/exceptions.dart';
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

  Future<void> _createUserAndSignOut() async {
    await fakeAuthRepository.createUserWithEmailAndPassword(
      email,
      password,
    );
    expect(fakeAuthRepository.currentUser, user);
    expect(fakeAuthRepository.authStateChanges(), emits(user));

    await fakeAuthRepository.signOut();
    expect(fakeAuthRepository.currentUser, null);
    expect(fakeAuthRepository.authStateChanges(), emits(null));
  }

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
    () {
      addTearDown(fakeAuthRepository.dispose);

      expect(
        fakeAuthRepository.signInWithEmailAndPassword(email, password),
        throwsA(isA<UserNotFoundException>()),
      );
      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    },
  );

  test(
    'signInWithEmailAndPassword sets user',
    () async {
      addTearDown(fakeAuthRepository.dispose);

      await _createUserAndSignOut();

      await fakeAuthRepository.signInWithEmailAndPassword(
        email,
        password,
      );
      expect(fakeAuthRepository.currentUser, user);
      expect(fakeAuthRepository.authStateChanges(), emits(user));
    },
  );

  test(
    'signInWithEmailAndPassword throws WrongPasswordException',
    () async {
      addTearDown(fakeAuthRepository.dispose);

      await _createUserAndSignOut();

      expect(
        fakeAuthRepository.signInWithEmailAndPassword(email, 'wrongpassword'),
        throwsA(isA<WrongPasswordException>()),
      );
    },
  );

  test(
    'createUserWithEmailAndPassword throws EmailAlreadyInUseException',
    () async {
      addTearDown(fakeAuthRepository.dispose);

      await _createUserAndSignOut();

      expect(
        fakeAuthRepository.createUserWithEmailAndPassword(email, password),
        throwsA(isA<EmailAlreadyInUseException>()),
      );
    },
  );

  test(
    'createUserWithEmailAndPassword throws WeakPasswordException',
    () {
      addTearDown(fakeAuthRepository.dispose);

      expect(
        fakeAuthRepository.createUserWithEmailAndPassword(email, 'short'),
        throwsA(isA<WeakPasswordException>()),
      );
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
