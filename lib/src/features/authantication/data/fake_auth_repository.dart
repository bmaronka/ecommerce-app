import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authantication/domain/fake_app_user.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  FakeAuthRepository({this.addDelay = true});

  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  final List<FakeAppUser> _users = [];

  Stream<AppUser?> authStateChanges() => _authState.stream;

  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    for (final u in _users) {
      if (u.email == email && u.password == password) {
        _authState.value = u;
        return;
      }

      if (u.email == email && u.password != password) {
        throw Exception('Wrong password'.hardcoded);
      }
    }

    throw Exception('User not found'.hardcoded);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    for (final u in _users) {
      if (u.email == email) {
        throw Exception('Email already in use'.hardcoded);
      }
    }

    if (password.length < 8) {
      throw Exception('Password is too weak'.hardcoded);
    }

    _createNewUser(email, password);
  }

  Future<void> signOut() async {
    await delay(addDelay);
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email, String password) {
    final user = FakeAppUser(
      uid: email.split('').reversed.join(),
      email: email,
      password: password,
    );

    _users.add(user);
    _authState.value = user;
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final authRepo = FakeAuthRepository();

  ref.onDispose(authRepo.dispose);
  return authRepo;
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
