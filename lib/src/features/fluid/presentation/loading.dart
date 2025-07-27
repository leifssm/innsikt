import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/components/info_card.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:logger/logger.dart';

typedef ComponentBuilder<T> = Widget Function(T value);
typedef LoadingComponentBuilder = Widget Function();
typedef ErrorComponentBuilder =
    Widget Function(Object error, StackTrace? stackTrace);

Widget _defaultLoadingBuilder() {
  return const Center(child: CircularProgressIndicator());
}

Widget _defaultErrorBuilder(Object error, StackTrace? stackTrace) {
  return InfoCard.error(error.toString());
}

class Loading<T> extends StatelessWidget {
  static final logger = Logger();

  final Rx<Fluid<T>> value;
  final ComponentBuilder<T> builder;
  final LoadingComponentBuilder loadingBuilder;
  final LoadingComponentBuilder waitingBuilder;
  final ErrorComponentBuilder errorBuilder;
  final bool showOnlySuccess;

  const Loading({
    super.key,
    required this.value,
    required this.builder,
    this.showOnlySuccess = false,
    this.errorBuilder = _defaultErrorBuilder,
    this.loadingBuilder = _defaultLoadingBuilder,
    this.waitingBuilder = _defaultLoadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (value.isError) {
        logger.e(
          'Error in Loading widget',
          error: value.error,
          stackTrace: value.stackTrace,
        );
      }
      if (showOnlySuccess && !value.isSuccess) {
        return const SizedBox.shrink();
      }
      return switch (value.value.status) {
        FluidStatus.success => builder(value.value.data!),
        FluidStatus.loading => loadingBuilder(),
        FluidStatus.error => errorBuilder(value.error!, value.stackTrace),
        FluidStatus.waiting => waitingBuilder(),
      };
    });
  }
}
