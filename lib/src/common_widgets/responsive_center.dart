import 'package:ecommerce_app/src/constants/breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    required this.child,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: maxContentWidth,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      );
}

class ResponsiveSliverCenter extends StatelessWidget {
  const ResponsiveSliverCenter({
    required this.child,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: ResponsiveCenter(
          maxContentWidth: maxContentWidth,
          padding: padding,
          child: child,
        ),
      );
}
