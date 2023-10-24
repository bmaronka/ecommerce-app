import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:mockito/annotations.dart';

// ignore: unused_import
import 'mocks.mocks.dart';

@GenerateMocks([
  FakeAuthRepository,
  RemoteCartRepository,
  LocalCartRepository,
])
void main() {}
