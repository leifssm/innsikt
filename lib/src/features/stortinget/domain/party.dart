import 'package:dart_mappable/dart_mappable.dart';

part 'party.mapper.dart';

@MappableClass()
class Party with PartyMappable {
  /// Element som definerer identifikator for partiet
  final String id;

  /// Element som definerer navnet til partiet
  @MappableField(key: 'navn')
  final String name;
  
  Party({
    required this.id,
    required this.name,
  });

  static final fromJson = PartyMapper.fromJson;
}
