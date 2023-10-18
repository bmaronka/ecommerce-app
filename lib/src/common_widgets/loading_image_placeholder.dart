import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class LoadingImagePlaceholder extends StatelessWidget {
  const LoadingImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(bottom: Sizes.p8),
        color: Colors.white,
        height: 100,
        width: 100,
      );
}
