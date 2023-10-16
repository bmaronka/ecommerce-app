import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({required this.imageUrl});

  final String imageUrl;

  // TODO: Use [CachedNetworkImage] if the url points to a remote resource
  @override
  Widget build(BuildContext context) => Image.asset(imageUrl);
}
