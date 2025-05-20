import 'package:dart_mappable/dart_mappable.dart';

part 'related_case.mapper.dart';


@MappableEnum()
enum RelationType {
  /// ikke_spesifisert
  @MappableValue(0) notSpecified,
  /// ukjent
  @MappableValue(1) unknown,
  /// relatertdiv
  @MappableValue(2) relatedMisc,
  /// fellesinnst
  @MappableValue(3) jointRecommendation,
  /// sammekilde
  @MappableValue(4) sameSource,
  /// oversendtfor
  @MappableValue(5) sentOnBehalf,
  /// oversendtfra
  @MappableValue(6) sentFrom,
  /// tilbakemeld
  @MappableValue(7) feedback,
  /// tilbakeprop
  @MappableValue(8) backwardPropagation,
  /// fremmetigjen
  @MappableValue(9) resubmitted,
  /// tidlfremmet
  @MappableValue(10) previouslySubmitted,
  /// sakgrunnlag
  @MappableValue(11) caseBackground;
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

