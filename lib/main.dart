import 'dart:async';

import 'package:ecommerce_app/src/app.dart';
import 'package:flutter/material.dart';

void main() => runZonedGuarded(
      () {
        WidgetsFlutterBinding.ensureInitialized();
        runApp(const MyApp());
        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.presentError(details);
        };
        ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: const Text('An error occurred'),
              ),
              body: Center(child: Text(details.toString())),
            );
      },
      (Object error, StackTrace stack) => debugPrint(error.toString()),
    );
