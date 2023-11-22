typedef UserID = String;

class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.emailVerified = false,
  });

  final UserID uid;
  final String? email;
  final bool emailVerified;

  Future<void> sendEmailVerification() async {} //implemented by subclasses

  Future<bool> isAdmin() => Future.value(false);

  Future<void> forceRefreshIdToken() async {} //implemented by subclasses

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}
