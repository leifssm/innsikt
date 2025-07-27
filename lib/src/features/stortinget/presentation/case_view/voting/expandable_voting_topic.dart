import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/summarized_voting.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_result.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/seating_chart.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/simple_voting_ratio.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_ratio.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/utils/extensions/units.dart';
import 'package:innsikt/src/utils/standalone_controller_mixin.dart';

class ExpandableVotingTopicController extends GetxController {
  ExpandableVotingTopicController(this.voting);

  final SummarizedVoting voting;
  final isExpanded = false.obs;
  final votingResult = Fluid.init<VotingResult>();

  void toggle() {
    fetchComplex();
    isExpanded.toggle();
  }

  void fetchComplex() {
    if (votingResult.isWaiting) {
      votingResult.updateAsync(
        () => stortinget.getVotingResults(voting.caseVote.votingId),
      );
    }
  }
}

class ExpandableVotingTopic extends GetView<ExpandableVotingTopicController>
    with StandaloneControllerMixin {
  final SummarizedVoting voting;

  @override
  String get tag => voting.caseVote.votingId.toString();

  const ExpandableVotingTopic({super.key, required this.voting});

  @override
  Widget build(BuildContext context) {
    Get.put(ExpandableVotingTopicController(voting), tag: tag);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 600,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(1.unit),
          child: Obx(
            () => Column(
              spacing: 1.unit,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: controller.toggle,
                        child: Text.rich(
                          TextSpan(
                            children:
                                controller.voting.items.indexed
                                    .map(
                                      (item) => TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "${item.$1 == 0 ? "" : "\n\n"}${item.$2.suggestion.title.trim()}:\n",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(text: item.$2.voteReason),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // AnimatedSize(duration: Durations.medium1, child: Text("hellfjo")),
                AnimatedCrossFade(
                  firstChild: SizedBox(
                    height: 80,
                    // width: 400,
                    child: SimpleVotingRatio(
                      forVotes: voting.caseVote.allFor,
                      againstVotes: voting.caseVote.allAgainst,
                      absentVotes: voting.caseVote.allAbsent,
                      vertical: true,
                    ),
                  ),
                  secondChild: Loading(
                    value: controller.votingResult,
                    builder:
                        (votingResult) => Column(
                          spacing: 1.unit,
                          children: [
                            SizedBox(
                              height: 80,
                              child: VotingRatio(
                                key: ValueKey(votingResult.votingId),
                                representativeVotingResult:
                                    votingResult.results,
                                vertical: true,
                              ),
                            ),
                            SeatingChart(
                              representativeVotingResult: votingResult.results,
                            ),
                          ],
                        ),
                  ),
                  firstCurve: Curves.fastOutSlowIn,
                  secondCurve: Curves.fastOutSlowIn,
                  crossFadeState:
                      controller.isExpanded.value
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                  duration: Durations.medium1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
