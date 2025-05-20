import 'package:dart_mappable/dart_mappable.dart';

part 'publication_reference.mapper.dart';

@MappableEnum()
enum PublicationType {
  @MappableValue(0) notSpecified,
  @MappableValue(1) government,
  @MappableValue(2) doc3,
  @MappableValue(3) doc8,
  @MappableValue(4) doc12,
  @MappableValue(5) documentSeries,
  @MappableValue(6) reportSummary,
  @MappableValue(7) recommendation,
  @MappableValue(8) decision,
  @MappableValue(9) lawDecision,
  @MappableValue(10) lawAnnotation,
  @MappableValue(11) summary;
}

@MappableClass()
class PublicationReference with PublicationReferenceMappable {
  /// Inneholder elementer definererer en eksport id for publikasjonen. Denne har verdi bare dersom publikasjonen er tilgjengelig for eksport
  @MappableField(key: 'eksport_id')
  final String? exportId;

  /// Inneholder elementer definererer en lenke tekst for publikasjonen
  @MappableField(key: 'lenke_tekst')
  final String linkText;

  /// Inneholder elementer definererer en lenke url for publikasjonen.
  @MappableField(key: 'lenke_url')
  final String linkUrl;

  /// Inneholder elementer definererer en type for publikasjonen
  @MappableField(key: 'type')
  final PublicationType type;

  /// Inneholder elementer definererer en undertype for publikasjonen
  @MappableField(key: 'undertype')
  final String? subtype;


  const PublicationReference({
    this.exportId,
    required this.linkText,
    required this.linkUrl,
    required this.type,
    this.subtype,
  });

  static final fromJson = PublicationReferenceMapper.fromJson;
}