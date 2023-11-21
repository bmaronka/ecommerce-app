import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/src/app_bootstrap.dart';
import 'package:ecommerce_app/src/app_bootstrap_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appBootstrap = AppBootstrap();
  await appBootstrap.setupEmulators();
  final container = await appBootstrap.createFirebaseProviderContainer();
  final root = appBootstrap.createRootWidget(container: container);

  runApp(root);
}
