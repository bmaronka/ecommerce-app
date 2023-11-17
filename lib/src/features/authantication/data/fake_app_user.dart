import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';

class FakeAppUser extends AppUser {
  const FakeAppUser({
    required super.uid,
    required super.email,
    required this.password,
  });

  final String password;
}
