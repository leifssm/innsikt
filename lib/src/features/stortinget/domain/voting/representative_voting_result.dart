import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/representative/representative.dart';
import 'package:innsikt/src/features/stortinget/domain/representative/vara_representative.dart';

part 'representative_voting_result.mapper.dart';

@MappableEnum()
enum VoteType {
  @MappableValue(1)
  absent("ikke_tilstede"),
  @MappableValue(2)
  forVote("for"),
  @MappableValue(3)
  against("mot");

  final String name;
  const VoteType(this.name);

  @override
  String toString() => name;
}

@MappableClass()
class RepresentativeVotingResult with RepresentativeVotingResultMappable {
  @MappableField(key: 'representant')
  final Representative representative;

  @MappableField(key: 'vara_for')
  final VaraRepresentative? deputyFor;

  @MappableField(key: 'fast_vara_for')
  final VaraRepresentative? permanentDeputyFor;

  @MappableField(key: 'votering')
  final VoteType vote;

  const RepresentativeVotingResult({
    required this.representative,
    required this.deputyFor,
    required this.permanentDeputyFor,
    required this.vote,
  });
}
