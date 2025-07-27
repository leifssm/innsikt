import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/party.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/representative_voting_result.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/bar_graph_baseline.dart';
import 'package:innsikt/src/utils/standalone_controller_mixin.dart';

class VotingRatioController extends GetxController {
  final List<RepresentativeVotingResult> representativeVotingResult;

  VotingRatioController(this.representativeVotingResult);

  final forVotes = <RepresentativeVotingResult>[];
  final againstVotes = <RepresentativeVotingResult>[];
  final absentVotes = <RepresentativeVotingResult>[];
  final titles = ["For", "Imot", "Borte"];

  final graphData = GraphData.empty().obs;

  @override
  void onInit() {
    for (var result in representativeVotingResult) {
      final _ = switch (result.vote) {
        VoteType.forVote => forVotes,
        VoteType.against => againstVotes,
        VoteType.absent => absentVotes,
      }.add(result);
    }
    super.onInit();
    sortByParty();
  }

  int get totalYes => forVotes.length;
  int get totalNo => againstVotes.length;
  int get totalAbsent => absentVotes.length;
  int get totalVotes => totalYes + totalNo + totalAbsent;

  GraphBar _groupVotesByParty(List<RepresentativeVotingResult> results) {
    final grouped = <Party, int>{};

    for (var result in results) {
      grouped.update(
        result.representative.party,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final partyList =
        grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return partyList
        .map(
          (p) => GraphBarSection(
            label: p.key.name,
            color: p.key.color,
            amount: p.value,
          ),
        )
        .toList();
  }

  void sortByParty() {
    print("Sorting by party");
    graphData.value = GraphData(
      titles: titles,
      bars: [
        _groupVotesByParty(forVotes),
        _groupVotesByParty(againstVotes),
        _groupVotesByParty(absentVotes),
      ],
    );
  }
}

class VotingRatio extends GetView<VotingRatioController>
    with StandaloneControllerMixin {
  final List<RepresentativeVotingResult> representativeVotingResult;
  final bool vertical;

  const VotingRatio({
    required super.key,
    required this.representativeVotingResult,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    control(VotingRatioController(representativeVotingResult));

    return Obx(
      () => BarGraphBaseline(
        graphData: controller.graphData.value,
        vertical: vertical,
      ),
    );
  }
}
