import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAppUser implements AppUser {
  const FirebaseAppUser(this._user);

  final User _user;

  @override
  UserID get uid => _user.uid;

  @override
  String? get email => _user.email;

  @override
  bool get emailVerified => _user.emailVerified;

  @override
  Future<void> sendEmailVerification() => _user.sendEmailVerification();

  @override
  Future<bool> isAdmin() async {
    final idTokenResult = await _user.getIdTokenResult();
    final claims = idTokenResult.claims;

    return claims?['admin'] == true;
  }

  @override
  Future<void> forceRefreshIdToken() => _user.getIdToken(true);
}
