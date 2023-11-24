import 'package:ecommerce_app/src/app_bootstrap.dart';
import 'package:ecommerce_app/src/app_bootstrap_fakes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  final appBootstrap = AppBootstrap();
  final container = await appBootstrap.createFakesProviderContainer();
  final root = appBootstrap.createRootWidget(container: container);

  runApp(root);
}
