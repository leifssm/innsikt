import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/summarized_voting.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/bar_graph_baseline.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/simple_voting_ratio.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_ratio.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_ratio_type_switcher.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/utils/extensions/units.dart';
import 'package:innsikt/src/utils/widget_mapper.dart';

class VotingListController extends GetxController {
  final int caseId;
  final summarizedVotings = Fluid.init<SummarizedVotings>();
  final isExpanded = <bool>[].obs;

  VotingListController(this.caseId);

  void fetch() async {
    await summarizedVotings.updateAsync(
      () => stortinget.getSummarizedVotingsForCase(caseId),
    );
    isExpanded.assignAll(
      List.filled(summarizedVotings.data?.items.length ?? 0, false),
    );
  }

  void onVotingTopicClicked(int index, bool expanded) {
    isExpanded[index] = expanded;
    isExpanded.refresh();
  }
}

class VotingList extends GetView<VotingListController> {
  final int caseId;
  const VotingList({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    Get.put(VotingListController(caseId));

    return Column(
      children: [
        TextButton(
          onPressed: controller.fetch,
          child: Text("Hent avstemninger"),
        ),
        Loading(
          value: controller.summarizedVotings,
          builder:
              (votings) => Column(
                children: [
                  Column(
                    children:
                        votings.items
                            .map(
                              (voting) => Card(
                                child: Padding(
                                  padding: EdgeInsets.all(1.unit),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children:
                                              voting.items.indexed
                                                  .map(
                                                    (item) => TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${item.$1 == 0 ? "" : "\n\n"}${item.$2.suggestion.title.trim()}:\n",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              item
                                                                  .$2
                                                                  .voteReason,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      ),
                                      // SimpleVotingRatio(
                                      //   forVotes: voting.caseVote.allFor,
                                      //   againstVotes:
                                      //       voting.caseVote.allAgainst,
                                      //   absentVotes: voting.caseVote.allAbsent,
                                      // ),
                                      // VotingRatio(key: ValueKey(voting.caseVote.votingId),
                                      //   representativeVotingResult: voting.caseVote.,
                                      // ),
                                      VotingRatioTypeSwitcher(
                                        key: ValueKey(voting.caseVote.votingId),
                                        voting: voting,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),

                    // Card(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(1.unit),
                    //     child: Column(
                    //       children: [
                    //         Text('${voting.title}: '),
                    //         ...voting.items.map(
                    //           (item) => Text.rich(
                    //             TextSpan(
                    //               children: [
                    //                 TextSpan(
                    //                   text: "${item.suggestion.title}:\n",
                    //                   style: TextStyle(fontWeight: FontWeight.w500),
                    //                 ),
                    //                 TextSpan(text: item.voteReason),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
                ],
              ),
        ),
      ],
    );
  }
}
