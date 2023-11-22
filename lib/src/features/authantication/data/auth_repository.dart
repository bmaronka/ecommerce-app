import 'package:ecommerce_app/src/features/authantication/data/firebase_app_user.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<AppUser?> authStateChanges() => _auth.authStateChanges().map(_convertUser);

  AppUser? get currentUser => _convertUser(_auth.currentUser);

  Future<void> signInWithEmailAndPassword(String email, String password) => _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<void> createUserWithEmailAndPassword(String email, String password) => _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<void> signOut() => _auth.signOut();

  Stream<AppUser?> idTokenChanges() => _auth.idTokenChanges().map(_convertUser);

  AppUser? _convertUser(User? user) => user != null ? FirebaseAppUser(user) : null;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository(FirebaseAuth.instance);

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}

@Riverpod(keepAlive: true)
Stream<AppUser?> idTokenChanges(IdTokenChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.idTokenChanges();
}

@riverpod
FutureOr<bool> isCurrentUserAdmin(IsCurrentUserAdminRef ref) {
  final user = ref.watch(idTokenChangesProvider).value;
  if (user != null) {
    return user.isAdmin();
  } else {
    return false;
  }
}
