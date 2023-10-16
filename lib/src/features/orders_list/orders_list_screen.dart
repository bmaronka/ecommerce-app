import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/orders_list/order_card.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/models/order.dart';
import 'package:flutter/material.dart';

final orders = [
  Order(
    id: 'abc',
    userId: '123',
    items: {
      '1': 1,
      '2': 2,
      '3': 3,
    },
    orderStatus: OrderStatus.confirmed,
    orderDate: DateTime.now(),
    total: 104,
  ),
];

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  // TODO: Read from data source
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'.hardcoded),
        ),
        body: orders.isEmpty
            ? Center(
                child: Text(
                  'No previous orders'.hardcoded,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => ResponsiveCenter(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: OrderCard(
                          order: orders[index],
                        ),
                      ),
                      childCount: orders.length,
                    ),
                  ),
                ],
              ),
      );
}
