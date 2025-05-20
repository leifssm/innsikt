import 'package:dio/dio.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_call_adapter.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_list.dart';
import 'package:innsikt/src/features/stortinget/domain/case/detailed_case.dart';
import 'package:innsikt/src/features/stortinget/domain/party_list.dart';
import 'package:innsikt/src/features/stortinget/domain/sessions.dart';
import 'package:innsikt/src/features/stortinget/domain/storting_periods.dart';
import 'package:retrofit/retrofit.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';

part 'stortinget_repository.g.dart';

@RestApi(
  baseUrl: 'https://data.stortinget.no/eksport/',
  callAdapter: StortingetCallAdapter,
)
abstract class StortingetRepository {
  factory StortingetRepository(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger errorLogger,
  }) = _StortingetRepository;

  factory StortingetRepository.create() {
    const logWidth = 79;
    print("-" * logWidth);
    final dio = Dio(BaseOptions(queryParameters: {'format': 'JSON'}))
      ..interceptors.addAll([
        PrettyDioLogger(
          request: true,
          requestBody: true,
          responseBody: false,
          error: true,
          maxWidth: logWidth - 12,
        ),
        DioCacheInterceptor(
          options: CacheOptions(
            store: FileCacheStore('./cache'),
            keyBuilder: ({required Uri url, Map<String, String>? headers}) {
              var key = url.path.substring(9);
              final entries = url.queryParameters.entries.toList();
              entries.removeWhere((entry) => entry.key == "format");

              for (var i = 0; i < entries.length; i++) {
                final entry = entries[i];
                key += (i == 0) ? '@' : '&';
                key += '${entry.key}=${entry.value}';
              }

              return key;
            },
            policy: CachePolicy.forceCache,
          ),
        ),
      ]);

    return StortingetRepository(dio);
  }

  @GET('/partier')
  Future<PartyList> getParties({
    @Query('sesjonid') String? sessionId,
    @Query('stortingsperiodeid') String? periodId,
  });

  @GET('/allepartier')
  Future<PartyList> getAllParties();

  @GET('/stortingsperioder')
  Future<StortingPeriods> getStortingPeriods();

  @GET('/sesjoner')
  Future<Sessions> getSessions();

  /// If [sessionId] is null, the latest session is used.
  @GET('/saker')
  Future<CaseList> getCases({@Query('sesjonid') String? sessionId});

  @GET('/sak')
  Future<DetailedCase> getDetailedCase(@Query('sakid') int caseId);

  @GET('/allekomiteer')
  Future<CaseList> getAllCommittees();

  // @GET('/personbilde')
  // Future<File> _getProfile({
  //   @Query('personid') String personId,
  //   @Query('storrelse') String size,
  //   @Query('erstatningsbilde') bool? defaultPicture,
  // });

  // Future<File> getProfile({
  //   required String personId,
  //   required PictureSize size,
  //   bool? defaultPicture,
  // }) => _getProfile(
  //   personId: personId,
  //   size: size.value,
  //   defaultPicture: defaultPicture,
  // );

  @GET('/personbilde')
  Future<Sessions> getError();
}
