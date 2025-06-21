import 'package:innsikt/src/features/stortinget/domain/mappable_hooks.dart';
import 'package:innsikt/src/features/stortinget/domain/representative.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/time_range.dart';

part 'case_vote.mapper.dart';

@MappableEnum()
enum VotingMethod {
  @MappableValue(1)
  unspecified("ikke_spesifisert"),
  @MappableValue(2)
  electronic("elektronisk"),
  @MappableValue(3)
  rolecall("navneopprop"),
  @MappableValue(4)
  standingSitting("staaende_sittende"),
  @MappableValue(5)
  written("skriftlig");

  final String name;
  const VotingMethod(this.name);

  @override
  String toString() => name;
}

/// Dette er såkalt faste koder som kan benyttes i stedet for vanlig votering med bruk av voteringsknapper:
@MappableEnum()
enum VoteResultType {
  @MappableValue(0)
  manual("manuell"),
  @MappableValue(1)
  unanimouslyAdopted("enstemmig_vedtatt"),
  @MappableValue(2)
  adoptedAgaintNVotes("vedtatt_mot_N_stemmer"),
  @MappableValue(3)
  rejectedAgaintNVotes("forkastet_mot_N_stemmer"),
  @MappableValue(4)
  adoptedWithPresidentialDoublevote("vedtatt_med_president_dobbeltstemme"),
  @MappableValue(5)
  rejectedWithPresidentialDoublevote("forkastet_med_president_dobbeltstemme");

  final String name;
  const VoteResultType(this.name);

  @override
  String toString() => name;
}

@MappableClass()
class CaseVote with CaseVoteMappable {
  /// Element som definerer identifikator for en eventuell alternativ votering
  @MappableField(key: 'alternativ_votering_id')
  final int alterativeVotingId;

  /// Element som definerer antall representanter som stemte for ved personlig votering
  @MappableField(key: 'antall_for')
  final int allFor;

  /// Element som definerer antall representanter som ikke var til stede ved personlig votering
  @MappableField(key: 'antall_ikke_tilstede')
  final int allAbsent;

  /// Element som definerer antall representanter som stemte mot ved personlig votering
  @MappableField(key: 'antall_mot')
  final int allAgainst;

  /// Element som definerer trinn i behandlingsrekkefølgen (for lovsaker er det behandling i to møter i plenum, i noen tilfeller tre møter)
  @MappableField(key: 'behandlingsrekkefoelge')
  final int progressStep;

  /// Element som definerer saksnummer på dagsorden
  @MappableField(key: 'dagsorden_sak_nummer')
  final int agendaCaseId;

  /// Element som angir om voteringen er relatert til ett eller flere voteringsforslag eller til saken som helhet (true/false, true dersom voteringen er relatert til saken som helhet)
  @MappableField(key: 'fri_votering')
  final bool freeVoting;

  /// Element som definerer en eventuell kommentar til voteringen
  @MappableField(key: 'kommentar')
  final String? comment;

  /// Element som definerer kartnummer for møtet
  @MappableField(key: 'mote_kart_nummer')
  final int meetingChartNumber;

  /// Element som angir om voteringen ble utført med personlig stemmegivning
  @MappableField(key: 'personlig_votering')
  final bool personalVoting;

  /// Element som definerer den fra presidentskapet som er møteleder (se forespørsel etter representanter)
  @MappableField(key: 'president')
  final Representative president;

  /// Identifikator for spesifisert sak
  @MappableField(key: 'sak_id')
  final int caseId;

  /// Element som angir om tema for voteringen er vedtatt
  @MappableField(key: 'vedtatt')
  final bool processed;

  /// Element som definerer identifikator for voteringen
  @MappableField(key: 'votering_id')
  final int votingId;

  /// Dette er såkalt faste koder som kan benyttes i stedet for vanlig votering med bruk av voteringsknapper
  @MappableField(key: 'votering_resultat_type')
  final VoteResultType voteType;

  /// Unspecified
  @MappableField(key: 'votering_resultat_type_tekst')
  final String? voteTypeText;

  /// Element som definerer hva voteringen gjelder. Vanligvis hvilke voteringsforslag det voteres over, eventuelt hvilke deler av forslag(et) det voteres over. NB! Dette elementet må alltid sammenholdes med forslagsteksten for å vite hvilke deler av forslaget det voteres over.
  @MappableField(key: 'votering_tema')
  final String votingTopic;

  /// Element som definerer tidspunkt for voteringen
  @MappableField(key: 'votering_tid', hook: DateTranslator())
  final DateTime voteTime;

  /// Element som definerer metode for voteringen
  @MappableField(key: 'votering_metode', hook: DefaultValue(VotingMethod.unspecified))
  final VotingMethod votingMethod;

  /// Element som definerer resultat-tekst for voteringen
  @MappableField(key: 'votering_resultat_tekst')
  final String? voteResultText;

  const CaseVote({
    required this.alterativeVotingId,
    required this.president,
    required this.freeVoting,
    required this.votingTopic,
    required this.processed,
    required this.votingMethod,
    required this.personalVoting,
    required this.allFor,
    required this.allAgainst,
    required this.allAbsent,
    required this.progressStep,
    required this.meetingChartNumber,
    required this.agendaCaseId,
    required this.comment,
    required this.caseId,
    required this.votingId,
    required this.voteType,
    required this.voteTypeText,
    required this.voteResultText,
    required this.voteTime,
  });

  static final fromJson = CaseVoteMapper.fromJson;
}
