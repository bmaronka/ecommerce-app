import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/products_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ProductsRobot {
  const ProductsRobot(this.tester);

  final WidgetTester tester;

  Future<void> selectProduct({int atIndex = 0}) async {
    final finder = find.byKey(ProductCard.productCardKey);
    await tester.tap(finder.at(atIndex));
    await tester.pumpAndSettle();
  }

  void expectFindSearchBox() {
    final finder = find.byType(ProductsSearchTextField);
    expect(finder, findsOneWidget);
  }

  void expectFindAtLeastNProductCards(int count) {
    final finder = find.byType(ProductCard, skipOffstage: false);
    expect(finder, findsAtLeastNWidgets(count));
  }

  void expectProductsListLoaded() {
    expectFindSearchBox();
    expectFindAtLeastNProductCards(1);
  }

  // product page
  Future<void> setProductQuantity(int quantity) async {
    final finder = find.byIcon(Icons.add);
    expect(finder, findsOneWidget);
    for (var i = 1; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }
}
