import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/summarized_voting.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/bar_graph_baseline.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/expandable_voting_topic.dart';
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

  void fetchRelatedVotings() async {
    await summarizedVotings.updateAsync(
      () => stortinget.getSummarizedVotingsForCase(caseId),
    );
    isExpanded.assignAll(
      List.filled(summarizedVotings.data?.items.length ?? 0, false),
    );
  }

  void onVotingTopicClicked(int index, bool expanded) {
    isExpanded[index] = expanded;
    // isExpanded.refresh();
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
          onPressed: controller.fetchRelatedVotings,
          child: Text("Hent avstemninger"),
        ),
        Loading(
          value: controller.summarizedVotings,
          builder:
              (votings) => Column(
                children:
                    votings.items
                        .map(
                          (v) => ExpandableVotingTopic(
                            key: ValueKey(v.caseVote.votingId),
                            voting: v,
                          ),
                        )
                        .toList(),
              ),
        ),
      ],
    );
  }
}
