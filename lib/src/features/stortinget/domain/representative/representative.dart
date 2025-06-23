import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/county.dart';
import 'package:innsikt/src/features/stortinget/domain/mappable_hooks.dart';
import 'package:innsikt/src/features/stortinget/domain/party.dart';

part 'representative.mapper.dart';

@MappableEnum()
enum Gender {
  @MappableValue(1)
  female('Kvinne'),
  @MappableValue(2)
  male('Mann');

  final String name;
  const Gender(this.name);

  @override
  String toString() => name;
}

@MappableClass()
class Representative with RepresentativeMappable {
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

  @MappableField(key: 'fylke')
  final County county;

  @MappableField(key: 'parti')
  final Party party;

  @MappableField(key: 'vara_representant')
  final bool isVara;

  @MappableField(key: 'kjoenn')
  final Gender gender;

  const Representative({
    required this.id,
    required this.deathDate,
    required this.lastName,
    required this.birthDate,
    required this.firstName,
    required this.county,
    required this.party,
    required this.isVara,
    required this.gender,
  });

  get fullName => '$firstName $lastName';

  get isDeceased => deathDate != null;

  get age {
    if (isDeceased) {
      return birthDate.difference(deathDate!).inDays ~/ 365;
    } else {
      return DateTime.now().difference(birthDate).inDays ~/ 365;
    }
  }

  static final fromJson = RepresentativeMapper.fromJson;
}
