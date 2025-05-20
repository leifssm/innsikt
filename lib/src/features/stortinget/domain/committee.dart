import 'package:dart_mappable/dart_mappable.dart';

part 'committee.mapper.dart';

@MappableClass()
class Committee with CommitteeMappable {
  final String id;

  @MappableField(key: 'navn')
  final String name;

  const Committee({
    required this.id,
    required this.name,
  });

  static final fromJson = CommitteeMapper.fromJson;
}