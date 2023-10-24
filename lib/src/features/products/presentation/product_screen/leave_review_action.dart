import 'package:ecommerce_app/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/orders/domain/purchase.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:ecommerce_app/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LeaveReviewAction extends ConsumerWidget {
  const LeaveReviewAction({
    required this.productId,
    super.key,
  });

  final String productId;

  // TODO: Read from data source
  // TODO: Inject date formatter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchase = Purchase(orderId: 'abc', orderDate: DateTime.now());
    final dateFormatted = ref.watch(dateFormatterProvider).format(purchase.orderDate);

    return Column(
      children: [
        const Divider(),
        gapH8,
        ResponsiveTwoColumnLayout(
          spacing: Sizes.p16,
          breakpoint: 300,
          startFlex: 3,
          endFlex: 2,
          rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          startContent: Text('Purchased on $dateFormatted'.hardcoded),
          endContent: CustomTextButton(
            text: 'Leave a review'.hardcoded,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.green[700]),
            onPressed: () => context.goNamed(
              AppRoute.leaveReview.name,
              pathParameters: {'id': productId},
            ),
          ),
        ),
        gapH8,
      ],
    );
  }
}
