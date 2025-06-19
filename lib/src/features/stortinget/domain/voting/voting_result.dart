import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/representative_voting_result.dart';

part 'voting_result.mapper.dart';

@MappableClass()
class VotingResult with VotingResultMappable {
  @MappableField(key: 'votering_id')
  final int votingId;

  @MappableField(key: 'voteringsresultat_liste')
  final List<RepresentativeVotingResult> results;

  const VotingResult({required this.votingId, required this.results});

  static final fromJson = VotingResultMapper.fromJson;
}
