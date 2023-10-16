import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ItemQuantitySelector extends StatelessWidget {
  const ItemQuantitySelector({
    required this.quantity,
    this.maxQuantity = 10,
    this.itemIndex,
    this.onChanged,
    super.key,
  });

  final int quantity;
  final int maxQuantity;
  final int? itemIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black54,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onChanged != null && quantity > 1 ? () => onChanged!.call(quantity - 1) : null,
            ),
            SizedBox(
              width: 30.0,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onChanged != null && quantity < maxQuantity ? () => onChanged!.call(quantity + 1) : null,
            ),
          ],
        ),
      );
}
