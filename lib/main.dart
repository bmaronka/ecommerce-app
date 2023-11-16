import 'package:ecommerce_app/src/app_bootstrap.dart';
import 'package:ecommerce_app/src/app_bootstrap_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  // TODO: Initialize firebase

  final appBootstrap = AppBootstrap();
  final container = await createFirebaseProviderContainer();
  final root = appBootstrap.createRootWidget(container: container);

  runApp(root);
}
