import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/representative.dart';

part 'case_origin.mapper.dart';

@MappableClass()
class CaseOrigin with CaseOriginMappable {
  @MappableField(key: 'forslagstiller_liste')
  final List<Representative> proposers;

  const CaseOrigin({
    required this.proposers,
  });

  static final fromJson = CaseOriginMapper.fromJson;
}