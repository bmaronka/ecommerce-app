import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/reviews/application/fake_reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// ignore: unused_import
import 'mocks.mocks.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

@GenerateMocks([
  FakeAuthRepository,
  RemoteCartRepository,
  LocalCartRepository,
  CartService,
  FakeProductsRepository,
  FakeOrdersRepository,
  FakeCheckoutService,
  FakeReviewsRepository,
  FakeReviewsService,
])
void main() {}
