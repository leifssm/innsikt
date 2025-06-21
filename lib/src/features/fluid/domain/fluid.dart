import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum FluidStatus {
  // No data is available yet, waiting for the first fetch
  waiting,
  // The data is being fetched
  loading,
  // The data has been successfully fetched
  success,
  // An error occurred while fetching the data
  error,
}

class Fluid<T> {
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;
  final FluidStatus status;

  const Fluid._({this.data, this.error, this.stackTrace, required this.status});
  bool get isSuccess => status == FluidStatus.success;
  bool get isLoading => status == FluidStatus.loading;
  bool get isError => status == FluidStatus.error;
  bool get isWaiting => status == FluidStatus.waiting;

  static Fluid<T> success<T>(T data) {
    return Fluid<T>._(data: data, status: FluidStatus.success);
  }

  static Fluid<T> err<T>(Object error, [StackTrace? stackTrace]) {
    return Fluid<T>._(
      error: error,
      stackTrace: stackTrace,
      status: FluidStatus.error,
    );
  }

  static Fluid<T> loading<T>() {
    return Fluid<T>._(status: FluidStatus.loading);
  }

  static Fluid<T> waiting<T>() {
    return Fluid<T>._(status: FluidStatus.waiting);
  }

  static Rx<Fluid<T>> init<T>([T? initialData]) {
    if (initialData != null) {
      return Fluid.success<T>(initialData).obs;
    }
    return Fluid.waiting<T>().obs;
  }
}

extension GetAsyncExtension<T> on Rx<Fluid<T>> {
  bool get isSuccess => value.isSuccess;
  bool get isLoading => value.isLoading;
  bool get isError => value.isError;
  bool get isWaiting => value.isWaiting;

  T? get data => value.data;
  Object? get error => value.error;
  StackTrace? get stackTrace => value.stackTrace;

  Future<void> updateAsync(
    Future<T> Function() future, [
    bool keepOld = false,
  ]) async {
    if (!keepOld || value.isWaiting) value = Fluid.loading();
    try {
      value = Fluid.success(await future());
    } catch (e, stack) {
      value = Fluid.err(e, stack);
    }
  }
}
