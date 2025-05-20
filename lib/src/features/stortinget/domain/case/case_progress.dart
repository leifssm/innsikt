import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_progress_step.dart';

part 'case_progress.mapper.dart';

@MappableClass()
class CaseProgress with CaseProgressMappable {
  final String id;
  
  @MappableField(key: 'navn')
  final String name;
  
  @MappableField(key: 'saksgang_steg_liste')
  final List<CaseProgressStep> progressList;

  const CaseProgress({
    required this.id,
    required this.name,
    required this.progressList,
  });

  static final fromJson = CaseProgressMapper.fromJson;
}