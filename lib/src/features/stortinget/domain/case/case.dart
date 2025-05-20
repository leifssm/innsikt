import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_topic.dart';
import 'package:innsikt/src/features/stortinget/domain/committee.dart';
import 'package:innsikt/src/features/stortinget/domain/mappable_hooks.dart';
import 'package:innsikt/src/features/stortinget/domain/representative.dart';

part 'case.mapper.dart';


@MappableEnum()
enum CaseType {
  /// budsjett
  @MappableValue(1) budget,
  /// lovsak
  @MappableValue(2) lawCase,
  /// alminneligsak
  @MappableValue(3) ordinaryCase;
}


@MappableEnum()
enum CaseStatus {
  /// varlset
  @MappableValue(1) notified,
  /// mottatt
  @MappableValue(2) recieved,
  /// til_behandling
  @MappableValue(3) inProgress,
  /// behandlet
  @MappableValue(4) processed,
  /// trukket
  @MappableValue(5) withdrawn,
  /// bortfalt
  @MappableValue(6) lapsed,
  /// API spesifiserer ikke
  @MappableValue(7) unspecified;
}


@MappableEnum()
enum CaseDocumentGroup {
  @MappableValue(0) idfk,
  /// proposisjon
  @MappableValue(1) proposition,
  /// melding
  @MappableValue(2) report,
  /// redegjoerelse
  @MappableValue(3) statement,
  /// representantforslag
  @MappableValue(4) privateMemberBill,
  /// dokumentserien
  @MappableValue(5) documentSeries,
  /// innstillingssaker
  @MappableValue(6) recommendationCases,
  /// innberetning
  @MappableValue(7) reportSummary,
  @MappableValue(8) idfk1;

}


@MappableEnum()
enum RecommendationCode {
  @MappableValue(0) idfk,
  /// Innstilling til Stortinget. Komiteens innstillinger om alminnelige saker og budsjettsaker.
  @MappableValue(1) recommendationStortinget,
  /// Innstilling til Stortinget (lovvedtak). Komiteenes innstillinger om lovvedtak.
  @MappableValue(2) recommendationLaw;
}



@MappableClass()
class Case with CaseMappable {
  /// Element som definerer identifikator for saken
  @MappableField(key: 'id')
  final int id;

  /// Element som definerer tittel for saken
  @MappableField(key: 'tittel')
  final String title;

  /// Element som definerer kort tittel for saken
  @MappableField(key: 'korttittel')
  final String shortTitle;

  /// Element som definerer kort tittel for saken
  final CaseStatus status;

  /// Element som definerer type sak
  final CaseType type;

  /// Element som definerer henvisning for saken
  @MappableField(key: 'henvisning')
  final String? referral;
  
  /// Element som definerer identifikator for sesjonen der saken ble behandlet
  @MappableField(key: 'behandlet_sesjon_id')
  final String? sessionId;

  /// Element som definerer identifikator for den opprinnelige saken som ble fremmet for Stortinget
  @MappableField(key: 'sak_fremmet_id')
  final int originalCaseId;

  /// Element som definerer dokumentgruppe for saken
  @MappableField(key: 'dokumentgruppe')
  final CaseDocumentGroup documentGroup;
  
  /// Inneholder elementer for alle emner som saken er assosiert med
  @MappableField(key: 'emne_liste')
  final List<CaseTopic> topics;
  
  /// Inneholder elementer for alle representanter som er forslagstillere dersom det er relevant for saken
  @MappableField(key: 'forslagstiller_liste', hook: DefaultValue(<Representative>[]))
  final List<Representative> proposers;
  
  /// Element som definerer identifikator for instillingen
  @MappableField(key: 'innstilling_id')
  final int recommendationId;
  
  /// Element som definerer innstillingskode
  @MappableField(key: 'innstilling_kode')
  final RecommendationCode recommendationCode;
  
  /// Element som definerer komite som evt behanlder saken
  @MappableField(key: 'komite')
  final Committee? committee;

  /// Inneholder elementer for alle representanter som er saksordførere for saken
  @MappableField(key: 'saksordfoerer_liste')
  final List<Representative> rapporteurs;

  /// Element som definerer dato for siste statusendring for saken
  @MappableField(key: 'sist_oppdatert_dato', hook: DateTranslator())
  final DateTime modifiedDate;

  const Case({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.status,
    required this.type,
    required this.referral,
    required this.sessionId,
    required this.originalCaseId,
    required this.documentGroup,
    required this.topics,
    required this.proposers,
    required this.recommendationId,
    required this.recommendationCode,
    required this.committee,
    required this.rapporteurs,
    required this.modifiedDate,
  });

  static final fromJson = CaseMapper.fromJson;
}