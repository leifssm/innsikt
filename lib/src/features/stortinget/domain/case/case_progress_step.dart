import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/mappable_hooks.dart';

part 'case_progress_step.mapper.dart';

@MappableClass()
class CaseProgressStep with CaseProgressStepMappable {
  final String id;
  
  @MappableField(key: 'navn')
  final String name;

  @MappableField(key: 'steg_nummer')
  final int step;
  
  @MappableField(key: 'uaktuell', hook: FlipBool())
  final bool relevant;

  const CaseProgressStep({
    required this.id,
    required this.name,
    required this.step,
    required this.relevant,
  });

  static final fromJson = CaseProgressStepMapper.fromJson;
}