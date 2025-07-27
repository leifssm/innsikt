import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_list.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/summarized_voting.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_result.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/simple_voting_ratio.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_ratio.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/utils/standalone_controller_mixin.dart';

class VotingRatioTypeSwitcherController extends GetxController {
  VotingRatioTypeSwitcherController(this.voting);

  final SummarizedVoting voting;
  final showSimple = true.obs;
  final detailedVoteData = Fluid.init<VotingResult>();

  void fetchComplex() {
    if (!detailedVoteData.isWaiting) return;
    detailedVoteData.updateAsync(
      () => stortinget.getVotingResults(voting.caseVote.votingId),
    );
  }
}

class VotingRatioTypeSwitcher extends GetView<VotingRatioTypeSwitcherController>
    with StandaloneControllerMixin {
  final SummarizedVoting voting;

  const VotingRatioTypeSwitcher({super.key, required this.voting});

  @override
  Widget build(BuildContext context) {
    control(VotingRatioTypeSwitcherController(voting));

    final vertical = context.responsiveValue(mobile: true, desktop: false);

    votingRatioBuilder(detailedVoting) => VotingRatio(
      key: ValueKey(detailedVoting.votingId),
      representativeVotingResult: detailedVoting.results,
      vertical: vertical,
    );

    simpleVotingRatioBuilder() => SimpleVotingRatio(
      forVotes: voting.caseVote.allFor,
      againstVotes: voting.caseVote.allAgainst,
      absentVotes: voting.caseVote.allAbsent,
      vertical: vertical,
    );

    // context.responsiveValue()

    return Column(
      children: [
        TextButton(
          onPressed: controller.showSimple.toggle,
          child: Text("Toggle Type"),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          child: SizedBox(
            height: 150,
            child: Obx(() {
              if (controller.showSimple.value) return simpleVotingRatioBuilder();
              controller.fetchComplex();
              return Loading(
                value: controller.detailedVoteData,
                builder: votingRatioBuilder,
                waitingBuilder: simpleVotingRatioBuilder,
                loadingBuilder: simpleVotingRatioBuilder,
              );
              // return VotingRatio(
              //   key: ValueKey(voting.caseVote.votingId),
              //   representativeVotingResult: voting.caseVote.representativeVotingResults,
              // );
            }),
          ),
        ),
      ],
    );
  }
}
