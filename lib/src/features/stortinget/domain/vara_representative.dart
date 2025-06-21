import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/county.dart';
import 'package:innsikt/src/features/stortinget/domain/mappable_hooks.dart';
import 'package:innsikt/src/features/stortinget/domain/party.dart';
import 'package:innsikt/src/features/stortinget/domain/representative.dart';

part 'vara_representative.mapper.dart';

@MappableClass()
class VaraRepresentative with VaraRepresentativeMappable {
  @MappableField(key: 'id')
  final String id;

  @MappableField(key: 'doedsdato', hook: DateTranslator())
  final DateTime? deathDate;

  @MappableField(key: 'etternavn')
  final String lastName;

  @MappableField(key: 'foedselsdato', hook: DateTranslator())
  final DateTime birthDate;

  @MappableField(key: 'fornavn')
  final String firstName;

  @MappableField(key: 'kjoenn')
  final Gender gender;

  const VaraRepresentative({
    required this.id,
    required this.deathDate,
    required this.lastName,
    required this.birthDate,
    required this.firstName,
    required this.gender,
  });

  get fullName => '$firstName $lastName';

  static final fromJson = VaraRepresentativeMapper.fromJson;
}
