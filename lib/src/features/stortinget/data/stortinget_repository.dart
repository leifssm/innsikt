import 'package:dio/dio.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_call_adapter.dart';
import 'package:innsikt/src/features/stortinget/domain/party_list.dart';
import 'package:innsikt/src/features/stortinget/domain/sessions.dart';
import 'package:innsikt/src/features/stortinget/domain/storting_periods.dart';
import 'package:retrofit/retrofit.dart';

part 'stortinget_repository.g.dart';

@RestApi(baseUrl: 'https://data.stortinget.no/eksport/', callAdapter: StortingetCallAdapter)
abstract class StortingetRepository {
  factory StortingetRepository(Dio dio, {String? baseUrl}) =
      _StortingetRepository;

  factory StortingetRepository.create() {
    final dio = Dio(BaseOptions(queryParameters: {'format': 'JSON'}));
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

  // @GET('/saker')
  // Future<CaseList> getCases({
  //   @Query('sesjonid') String? sessionId,
  // });

  @GET('/personbilde')
  Future<Sessions> getError();
}
