import 'dart:async';

import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/exceptions/async_error_logger.dart';
import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/sembast_cart_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        _configRouter();

        final localCartRepository = await SembastCartRepository.makeDefault();
        final container = ProviderContainer(
          overrides: [
            localCartRepositoryProvider.overrideWithValue(localCartRepository),
          ],
          observers: [
            AsyncErrorLogger(),
          ],
        );
        container.read(cartSyncServiceProvider);

        final errorLogger = container.read(errorLoggerProvider);
        _setErrorHandlers(errorLogger);

        runApp(
          UncontrolledProviderScope(
            container: container,
            child: MyApp(),
          ),
        );
      },
      (Object error, StackTrace stack) => debugPrint(error.toString()),
    );

void _configRouter() {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
}

void _setErrorHandlers(ErrorLogger errorLogger) {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
}
