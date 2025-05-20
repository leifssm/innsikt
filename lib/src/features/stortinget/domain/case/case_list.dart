import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case.dart';

part 'case_list.mapper.dart';

@MappableClass()
class CaseList with CaseListMappable {
  @MappableField(key: 'sesjon_id')
  final String sessionId;

  @MappableField(key: 'saker_liste')
  final List<Case> cases;

  CaseList({
    required this.sessionId,
    required this.cases,
  });

  static final fromJson = CaseListMapper.fromJson;
}