import 'package:innsikt/src/features/stortinget/domain/voting/case_vote.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_result.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_suggestion.dart';

class SummarizedVotingItem {
  final String voteReason;
  final VotingSuggestion suggestion;
  final VotingResult? votingResult;

  const SummarizedVotingItem({
    required this.voteReason,
    required this.suggestion,
    this.votingResult,
  });
}

class SummarizedVoting {
  final String title;
  final CaseVote caseVote;
  final List<SummarizedVotingItem> items;

  const SummarizedVoting({
    required this.title,
    required this.caseVote,
    required this.items,
  });
}

class SummarizedVotings {
  final int caseId;
  final List<SummarizedVoting> items;

  const SummarizedVotings({required this.caseId, required this.items});
}
