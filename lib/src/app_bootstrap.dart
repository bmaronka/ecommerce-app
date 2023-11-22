import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:ecommerce_app/src/features/authantication/application/user_token_refresh_service.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBootstrap {
  Widget createRootWidget({required ProviderContainer container}) {
    final errorLogger = container.read(errorLoggerProvider);
    _registerErrorHandlers(errorLogger);
    container.read(cartSyncServiceProvider);
    container.read(userTokenRefreshServiceProvider);

    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
  }

  void _registerErrorHandlers(ErrorLogger errorLogger) {
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
            title: Text('An error occurred'.hardcoded),
          ),
          body: Center(child: Text(details.toString())),
        );
  }
}
