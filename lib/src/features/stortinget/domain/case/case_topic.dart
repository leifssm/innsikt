import 'package:dart_mappable/dart_mappable.dart';

part 'case_topic.mapper.dart';

@MappableClass()
class CaseTopic with CaseTopicMappable {
  @MappableField(key: 'id')
  final int id;

  @MappableField(key: 'er_hovedemne')
  final bool primaryTopic;

  @MappableField(key: 'navn')
  final String navn;

  /// Element som definerer underemne_liste for saken
  @MappableField(key: 'underemne_liste')
  final List<CaseTopic> subTopics;

  const CaseTopic({
    required this.id,
    required this.primaryTopic,
    required this.navn,
    required this.subTopics,
  });

  static final fromJson = CaseTopicMapper.fromJson;
}