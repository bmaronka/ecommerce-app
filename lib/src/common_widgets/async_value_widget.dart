import 'package:ecommerce_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.data,
    this.loading,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function()? loading;

  @override
  Widget build(BuildContext context) => value.when(
        data: data,
        error: (error, stacktrace) => Center(child: ErrorMessageWidget(error.toString())),
        loading: loading ?? () => Center(child: CircularProgressIndicator()),
      );
}

class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget({
    required this.value,
    required this.data,
    this.loading,
    super.key,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function()? loading;

  @override
  Widget build(BuildContext context) => value.when(
        data: data,
        error: (error, stacktrace) => SliverToBoxAdapter(child: Center(child: ErrorMessageWidget(error.toString()))),
        loading: loading ?? () => SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      );
}
