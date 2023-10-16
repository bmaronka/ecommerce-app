import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class ProductsSearchTextField extends StatefulWidget {
  const ProductsSearchTextField({super.key});

  @override
  State<ProductsSearchTextField> createState() => _ProductsSearchTextFieldState();
}

class _ProductsSearchTextFieldState extends State<ProductsSearchTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) => TextField(
          controller: _controller,
          autofocus: false,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: 'Search products'.hardcoded,
            icon: const Icon(Icons.search),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    onPressed: _controller.clear,
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          // TODO: Implement onChanged
          onChanged: null,
        ),
      );
}
