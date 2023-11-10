import 'package:ecommerce_app/src/features/orders/presentation/orders_list/order_card.dart';
import 'package:flutter_test/flutter_test.dart';

class OrdersRobot {
  const OrdersRobot(this.tester);

  final WidgetTester tester;

  void expectNOrderItems({int count = 1}) {
    final finder = find.byType(OrderCard);
    expect(finder, findsNWidgets(count));
  }
}
