import 'package:ecommerce_app/src/features/products/presentation/products_list/products_search_state_provider.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsSearchTextField extends ConsumerStatefulWidget {
  const ProductsSearchTextField({super.key});

  @override
  ConsumerState<ProductsSearchTextField> createState() => _ProductsSearchTextFieldState();
}

class _ProductsSearchTextFieldState extends ConsumerState<ProductsSearchTextField> {
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
                    onPressed: () {
                      _controller.clear();
                      ref.read(productsSearchQueryStateProvider.notifier).state = '';
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          onChanged: (value) => ref.read(productsSearchQueryStateProvider.notifier).state = value,
        ),
      );
}
