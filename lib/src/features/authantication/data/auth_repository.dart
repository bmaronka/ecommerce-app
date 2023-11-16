import 'dart:async';

import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

// TODO: Implement with Firebase
abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  // TODO: create and return repository
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
