import 'dart:async';

import 'package:ecommerce_app/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() => runZonedGuarded(
      () {
        WidgetsFlutterBinding.ensureInitialized();
        _configRouter();
        _setErrorHandlers();

        runApp(const MyApp());
      },
      (Object error, StackTrace stack) => debugPrint(error.toString()),
    );

void _configRouter() {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
}

void _setErrorHandlers() {
  FlutterError.onError = (FlutterErrorDetails details) => FlutterError.presentError(details);
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
}
