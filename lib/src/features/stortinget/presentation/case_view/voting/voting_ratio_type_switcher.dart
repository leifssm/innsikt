import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/components/op_obx.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/summarized_voting.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_result.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/seating_chart.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/simple_voting_ratio.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_ratio.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/utils/extensions/units.dart';

class VotingRatioTypeSwitcherController extends GetxController {
  VotingRatioTypeSwitcherController(this.voting);

  final SummarizedVoting voting;
  final showSimple = true.obs;
  final votingResult = Fluid.init<VotingResult>();

  void toggleType() {
    fetchComplex();
    showSimple.toggle();
  }

  void fetchComplex() {
    if (votingResult.isWaiting) {
      votingResult.updateAsync(
        () => stortinget.getVotingResults(voting.caseVote.votingId),
      );
    }
  }
}

class VotingRatioTypeSwitcher
    extends GetView<VotingRatioTypeSwitcherController> {
  @override
  String get tag => voting.caseVote.votingId.toString();

  const VotingRatioTypeSwitcher({super.key, required this.voting});
  final SummarizedVoting voting;

  // bool get vertical =>
  //     Get.context!.responsiveValue(mobile: true, desktop: false);

  Widget simpleVotingRatioBuilder() => SimpleVotingRatio(
    forVotes: voting.caseVote.allFor,
    againstVotes: voting.caseVote.allAgainst,
    absentVotes: voting.caseVote.allAbsent,
    vertical: true,
  );

  Widget detailedVotingInfoBuilder(VotingResult votingResult) =>
      VotingRatio(votingResult: votingResult, vertical: true);

  @override
  Widget build(BuildContext context) {
    Get.put(VotingRatioTypeSwitcherController(voting), tag: tag);

    return Column(
      spacing: 1.unit,
      children: [
        TextButton(
          onPressed: controller.toggleType,
          child: Text("Toggle Type"),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 80),
          child: Obx(() {
            if (controller.showSimple.value) {
              return simpleVotingRatioBuilder();
            }
            return Loading(
              value: controller.votingResult,
              builder:
                  (votingResult) =>
                      VotingRatio(votingResult: votingResult, vertical: true),
            );
          }),
        ),
        Show(
          controller.showSimple,
          negate: true,
          builder:
              () => Loading(
                value: controller.votingResult,
                builder:
                    (votingResult) => SeatingChart(
                      representativeVotingResult: votingResult.results,
                    ),
              ),
        ),
      ],
    );
  }
}
