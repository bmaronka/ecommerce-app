import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/data/firebase_app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

//Created to learn how to work with firebase_auth_mocks package
void main() {
  late FirebaseAuth auth;

  late AuthRepository authRepository;

  const email = 'test@test.com';
  const password = '123123123';
  final mockUser = MockUser(
    email: email,
    uid: email.split('').reversed.join(),
  );
  final testUser = FirebaseAppUser(mockUser);

  setUp(() {
    auth = MockFirebaseAuth(mockUser: mockUser);

    authRepository = AuthRepository(auth);
  });

  test(
    'currentUser is null',
    () {
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    },
  );

  test(
    'signInWithEmailAndPassword sets user',
    () async {
      expect(authRepository.currentUser, null);

      await authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emitsInOrder([null, testUser]));
    },
  );

  test(
    'createUserWithEmailAndPassword sets user',
    () async {
      expect(authRepository.currentUser, null);

      await authRepository.createUserWithEmailAndPassword(
        email,
        password,
      );

      expect(authRepository.currentUser?.email, testUser.email);
    },
  );

  test(
    'signOut unsets user',
    () async {
      expect(authRepository.currentUser, null);

      await authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emitsInOrder([null, testUser]));

      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emitsInOrder([testUser, null]));
    },
  );
}
