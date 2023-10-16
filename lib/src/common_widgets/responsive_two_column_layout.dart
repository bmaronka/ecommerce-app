import 'package:ecommerce_app/src/constants/breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveTwoColumnLayout extends StatelessWidget {
  const ResponsiveTwoColumnLayout({
    required this.startContent,
    required this.endContent,
    required this.spacing,
    this.startFlex = 1,
    this.endFlex = 1,
    this.breakpoint = Breakpoint.tablet,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final Widget startContent;
  final Widget endContent;
  final int startFlex;
  final int endFlex;
  final double breakpoint;
  final double spacing;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment columnCrossAxisAlignment;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= breakpoint) {
            return Row(
              mainAxisAlignment: rowMainAxisAlignment,
              crossAxisAlignment: rowCrossAxisAlignment,
              children: [
                Flexible(flex: startFlex, child: startContent),
                SizedBox(width: spacing),
                Flexible(flex: endFlex, child: endContent),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: columnMainAxisAlignment,
              crossAxisAlignment: columnCrossAxisAlignment,
              children: [
                startContent,
                SizedBox(height: spacing),
                endContent,
              ],
            );
          }
        },
      );
}
