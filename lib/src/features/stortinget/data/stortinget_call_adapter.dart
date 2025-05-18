import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/call_adapter.dart';

part 'stortinget_call_adapter.mapper.dart';

class StortingetCallAdapter<T> extends CallAdapter<Future<T>, Future<T>> {
  @override
  Future<T> adapt(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      throw StortingetError.fromJson(e.response!.data);
    }
  }
}

@MappableClass()
class StortingetError with StortingetErrorMappable implements Exception {
  @MappableField(key: 'feilkode')
  final int errorCode;
  @MappableField(key: 'feilmelding')
  final String message;
  @MappableField(key: 'forespoersel')
  final String request;
  @MappableField(key: 'metode')
  final String method;
  
  StortingetError({
    required this.errorCode,
    required this.message,
    required this.request,
    required this.method,
  });

  @override
  String toString() => 'StortingetError($errorCode): $message';

  static final fromJson = StortingetErrorMapper.fromJson;
}
