import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/components/info_card.dart';
import 'package:innsikt/src/components/standard_scaffold.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/domain/case/detailed_case.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_result.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/case_progress.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/reference_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/related_cases.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/representative_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/seating_chart.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/topic_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_ratio.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:logger/logger.dart';

class DetailedCaseViewController extends GetxController {
  final logger = Logger();
  final caseId = int.tryParse(Get.parameters['caseId'] ?? '');
  final detailedCase = Fluid.init<DetailedCase>();
  final voting = Fluid.init<Votings>();
  final result = Fluid.init<VotingResult>();

  @override
  void onReady() {
    super.onReady();
    if (caseId == null) {
      Get.back();
      logger.w("No caseId provided");
      return;
    }

    loadCase(caseId!);
  }

  void loadCase(int caseId) async {
    detailedCase.updateAsync(() => stortinget.getDetailedCase(caseId));
    await voting.updateAsync(() => stortinget.getVotingsForCase(caseId));
    if (!voting.isSuccess) return;
    final votingId = voting.data!.caseVotings.first.votingId;
    print(voting.data!.caseVotings.first.voteTypeText);
    result.updateAsync(() => stortinget.getVotingResults(votingId));
  }
}

class DetailedCaseView extends GetView<DetailedCaseViewController> {
  const DetailedCaseView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DetailedCaseViewController());

    return StandardScaffold(
      title: 'Sak ${controller.caseId}',
      body: Column(
        children: [
          Expanded(
            child: Loading(
              value: controller.detailedCase,
              builder:
                  (c) => SizedBox(
                    height: Get.height,
                    child: ListView(
                      children: [
                        Text(c.shortTitle, style: Get.textTheme.headlineSmall),
                        if (c.title != c.shortTitle)
                          Text(c.title, style: Get.textTheme.bodyMedium),
                        Text("Status: ${c.status}"),
                        Text("Type: ${c.type}"),
                        Text("Henvisning: ${c.referral}"),
                        Text("Dokumentgruppe: ${c.documentGroup}"),
                        TopicList(topics: c.topics),
                        InfoCard.neutral(
                          c.decisionSummary ?? "Ingen beslutning",
                        ),
                        Text("Forslagstillere:"),
                        RepresentativeList(representatives: c.proposers),
                        Text("Saksordførere:"),
                        RepresentativeList(representatives: c.rapporteurs),
                        Text(
                          "Prosessert: ${c.processed}",
                          style: Get.textTheme.titleMedium,
                        ),
                        Text("Instillingstekst: ${c.recommendationText}"),
                        Text("Parantestekster: ${c.parenthesisText}"),
                        CaseProgressTimeline(progress: c.caseProgress),
                        Text("Sak opprinnelse:"),
                        RepresentativeList(
                          representatives: c.caseOrigin.proposers,
                        ),
                        ReferenceList(references: c.publicationReferences),
                        RelatedCaseList(cases: c.relatedCases),
                        Text("Søkeord: ${c.searchWords.join(', ')}"),
                        Text("Vedtakstekst: ${c.decisionText}"),
                      ],
                    ),
                  ),
            ),
          ),
          Flexible(
            child: Loading(
              value: controller.voting,
              builder:
                  (r) => VotingList(votings: r)
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         controller.voting.data?.caseVotings.firstOrNull
                  //                 ?.toString() ??
                  //             "Ingen avstemning funnet",
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: SeatingChart(
                  //         representativeVotingResult: r.results,
                  //         disableInteraction: true,
                  //       ),
                  //     ),
                  //     Flexible(
                  //       child: VotingRatio(representativeVotingResult: r.results),
                  //     ),
                  //   ],
                  // ),
              // SeatingChart(representativeVotingResult: r.results)
            ),
          ),
        ],
      ),
    );
  }
}
