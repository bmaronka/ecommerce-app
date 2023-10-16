import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/constants/breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveScrollableCard extends StatelessWidget {
  const ResponsiveScrollableCard({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: ResponsiveCenter(
          maxContentWidth: Breakpoint.tablet,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p16),
                child: child,
              ),
            ),
          ),
        ),
      );
}
