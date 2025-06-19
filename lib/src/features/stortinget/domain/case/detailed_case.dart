import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_origin.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_progress.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_topic.dart';
import 'package:innsikt/src/features/stortinget/domain/committee.dart';
import 'package:innsikt/src/features/stortinget/domain/mappable_hooks.dart';
import 'package:innsikt/src/features/stortinget/domain/publication_reference.dart';
import 'package:innsikt/src/features/stortinget/domain/related_case.dart';
import 'package:innsikt/src/features/stortinget/domain/representative.dart';

part 'detailed_case.mapper.dart';

@MappableClass()
class DetailedCase with DetailedCaseMappable {
  /// Element som definerer identifikator for saken
  final int id;

  /// Element som definerer identifikator for sesjonen der saken ble behandlet
  @MappableField(key: 'sak_sesjon')
  final String sessionId;

  /// Element som definerer tittel for saken
  @MappableField(key: 'tittel')
  final String title;

  /// Element som definerer kort tittel for saken
  @MappableField(key: 'korttittel')
  final String shortTitle;

  final CaseStatus status;

  /// Element som definerer type sak
  final CaseType type;

  /// Element som definerer henvisning for saken
  @MappableField(key: 'henvisning')
  final String referral;

  /// Element som definerer dokumentgruppe for saken
  @MappableField(key: 'dokumentgruppe')
  final CaseDocumentGroup documentGroup;

  /// Inneholder elementer for alle emner som saken er assosiert med
  @MappableField(key: 'emne_liste')
  final List<CaseTopic> topics;

  /// Inneholder elementer for alle representanter som er forslagstillere dersom det er relevant for saken
  @MappableField(
    key: 'forslagstiller_liste',
    hook: DefaultValue(<Representative>[]),
  )
  final List<Representative> proposers;

  /// Element som definerer komite som evt behandler saken
  @MappableField(key: 'komite')
  final Committee? committee;

  /// Inneholder elementer for alle representanter som er saksordførere for saken
  @MappableField(key: 'saksordfoerer_liste')
  final List<Representative> rapporteurs;

  /// Element som definerer om saken er ferdigbehandlet eller ikke. Dersom elementet «status» har verdi «behandlet» betyr dette bare at saken er behandlet i komiteen.
  @MappableField(key: 'ferdigbehandlet')
  final bool processed;

  /// Element som definerer innstillingsteksten for saken
  @MappableField(key: 'innstillingstekst')
  final String? recommendationText;

  /// Element som definerer kortvedtakstekst for saken
  @MappableField(key: 'kortvedtak')
  final String? decisionSummary;

  /// Element som definerer vedtakstekst for saken
  @MappableField(key: 'parentestekst')
  final String? parenthesisText;

  /// Inneholder elementer for publikasjonsreferanser for saken
  @MappableField(key: 'publikasjon_referanse_liste')
  final List<PublicationReference> publicationReferences;

  /// Element som definerer nummer for saken
  @MappableField(key: 'sak_nummer')
  final int caseId;

  /// Element som inneholder andre elementer som definerer opphavet for saken, f.eks. forslagstillere for representantforslag og grunnlovsforslag.
  @MappableField(key: 'sak_opphav')
  final CaseOrigin caseOrigin;

  /// Inneholder elementer for alle andre som er relaterte til saken
  @MappableField(key: 'sak_relasjon_liste')
  final List<RelatedCase> relatedCases;

  /// Element som definerer saksgang for saken
  @MappableField(key: 'saksgang')
  final CaseProgress caseProgress;

  /// Inneholder alle stikkord som er assosiert med saken
  @MappableField(key: 'stikkord_liste')
  final List<String> searchWords;

  /// Element som definerer vedtakstekst for saken
  @MappableField(key: 'vedtakstekst')
  final String? decisionText;

  DetailedCase({
    required this.id,
    required this.sessionId,
    required this.title,
    required this.shortTitle,
    required this.status,
    required this.type,
    required this.referral,
    required this.documentGroup,
    required this.topics,
    required this.proposers,
    required this.committee,
    required this.rapporteurs,
    required this.processed,
    required this.recommendationText,
    required this.decisionSummary,
    required this.parenthesisText,
    required this.publicationReferences,
    required this.caseId,
    required this.caseOrigin,
    required this.relatedCases,
    required this.caseProgress,
    required this.searchWords,
    required this.decisionText,
  });

  static final fromJson = DetailedCaseMapper.fromJson;
}
