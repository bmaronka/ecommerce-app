typedef UserID = String;

class AppUser {
  const AppUser({
    required this.uid,
    this.email,
  });

  final UserID uid;
  final String? email;

  AppUser copyWith({
    String? uid,
    String? email,
  }) =>
      AppUser(
        uid: uid ?? this.uid,
        email: email ?? this.email,
      );

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
