import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/components/info_card.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';

typedef ComponentBuilder<T> = Widget Function(T value);
typedef LoadingComponentBuilder = Widget Function();
typedef ErrorComponentBuilder =
    Widget Function(Object error, StackTrace? stackTrace);

class LoadingController extends GetxController {}

Widget _defaultLoadingBuilder() {
  return const Center(child: CircularProgressIndicator());
}

Widget _defaultErrorBuilder(Object error, StackTrace? stackTrace) {
  return InfoCard.error(error.toString());
}

class Loading<T> extends GetView<LoadingController> {
  final Rx<Fluid<T>> value;
  final ComponentBuilder<T> builder;
  final LoadingComponentBuilder loadingBuilder;
  final ErrorComponentBuilder errorBuilder;

  const Loading({
    super.key,
    required this.value,
    required this.builder,
    this.errorBuilder = _defaultErrorBuilder,
    this.loadingBuilder = _defaultLoadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(LoadingController());

    return Obx(() {
      return switch (value.value.status) {
        FluidStatus.success => builder(value.value.data!),
        FluidStatus.loading => loadingBuilder(),
        FluidStatus.error => errorBuilder(value.error!, value.stackTrace)
      };
    });
  }
}
