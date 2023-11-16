import 'package:ecommerce_app/src/exceptions/exceptions.dart';
import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authantication/domain/fake_app_user.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.addDelay = true});

  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  final List<FakeAppUser> _users = [];

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    for (final u in _users) {
      if (u.email == email && u.password == password) {
        _authState.value = u;
        return;
      }

      if (u.email == email && u.password != password) {
        throw WrongPasswordException();
      }
    }

    throw UserNotFoundException();
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    for (final u in _users) {
      if (u.email == email) {
        throw EmailAlreadyInUseException();
      }
    }

    if (password.length < 8) {
      throw WeakPasswordException();
    }

    _createNewUser(email, password);
  }

  @override
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
