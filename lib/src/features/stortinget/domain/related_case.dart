import 'package:dart_mappable/dart_mappable.dart';

part 'related_case.mapper.dart';


@MappableEnum()
enum RelationType {
  /// ikke_spesifisert
  @MappableValue(0) notSpecified("ikke_spesifisert"),
  /// ukjent
  @MappableValue(1) unknown("ukjent"),
  /// relatertdiv
  @MappableValue(2) relatedMisc("relatertdiv"),
  /// fellesinnst
  @MappableValue(3) jointRecommendation("fellesinnst"),
  /// sammekilde
  @MappableValue(4) sameSource("sammekilde"),
  /// oversendtfor
  @MappableValue(5) sentOnBehalf("oversendtfor"),
  /// oversendtfra
  @MappableValue(6) sentFrom("oversendtfra"),
  /// tilbakemeld
  @MappableValue(7) feedback("tilbakemeld"),
  /// tilbakeprop
  @MappableValue(8) backwardPropagation("tilbakeprop"),
  /// fremmetigjen
  @MappableValue(9) resubmitted("fremmetigjen"),
  /// tidlfremmet
  @MappableValue(10) previouslySubmitted("tidlfremmet"),
  /// sakgrunnlag
  @MappableValue(11) caseBackground("sakgrunnlag");

  final String name;
  const RelationType(this.name);

  @override
  String toString() => name;
}

@MappableClass()
class RelatedCase with RelatedCaseMappable {
  /// Element som definerer id for den relaterte saken
  @MappableField(key: 'relatert_sak_id')
  final int caseId;

  /// Element som definerer korttittel for den relaterte saken
  @MappableField(key: 'relatert_sak_korttittel')
  final String shortTitle;

  /// Element som definerer typen relasjon mellom denne saken og den relaterte saken
  @MappableField(key: 'relasjon_type')
  final RelationType relationType;

  const RelatedCase({
    required this.caseId,
    required this.shortTitle,
    required this.relationType,

  });

  static final fromJson = RelatedCaseMapper.fromJson;
}

