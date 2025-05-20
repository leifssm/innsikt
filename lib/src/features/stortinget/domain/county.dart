import 'package:dart_mappable/dart_mappable.dart';

part 'county.mapper.dart';

@MappableClass()
class County with CountyMappable {
  final String id;

  @MappableField(key: 'navn')
  final String name;
  
  const County({
    required this.id,
    required this.name,
  });

  static final fromJson = CountyMapper.fromJson;
}