import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/orders_list/order_item_list_tile.dart';
import 'package:ecommerce_app/src/features/orders_list/order_status_label.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/models/item.dart';
import 'package:ecommerce_app/src/models/order.dart';
import 'package:ecommerce_app/src/utils/currency_formatter.dart';
import 'package:ecommerce_app/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.order,
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.grey[400]!),
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
        ),
        child: Column(
          children: [
            OrderHeader(order: order),
            const Divider(height: 1, color: Colors.grey),
            OrderItemsList(order: order),
          ],
        ),
      );
}

class OrderHeader extends StatelessWidget {
  const OrderHeader({required this.order, super.key});

  final Order order;

  // TODO: Inject currency formatter
  // TODO: Inject date formatter
  @override
  Widget build(BuildContext context) {
    final totalFormatted = kCurrencyFormatter.format(order.total);
    final dateFormatted = kDateFormatter.format(order.orderDate);

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order placed'.hardcoded.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  gapH4,
                  Text(dateFormatted),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total'.hardcoded.toUpperCase(),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  gapH4,
                  Text(totalFormatted),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderItemsList extends StatelessWidget {
  const OrderItemsList({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: OrderStatusLabel(order: order),
          ),
          for (var entry in order.items.entries)
            OrderItemListTile(
              item: Item(productId: entry.key, quantity: entry.value),
            ),
        ],
      );
}
