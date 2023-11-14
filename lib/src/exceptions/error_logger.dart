import 'package:ecommerce_app/src/exceptions/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) => debugPrint('$error, $stackTrace');

  void logAppException(AppException exception) => debugPrint('$exception');
}

@riverpod
ErrorLogger errorLogger(ErrorLoggerRef ref) => ErrorLogger();
