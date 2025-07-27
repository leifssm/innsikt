import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/components/info_card.dart';
import 'package:innsikt/src/components/standard_scaffold.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/domain/case/detailed_case.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/votings.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_result.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/case_progress.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/reference_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/related_cases.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/representative_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/topic_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_list.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:logger/logger.dart';

class DetailedCaseViewController extends GetxController {
  final logger = Logger();
  final caseId = int.tryParse(Get.parameters['caseId'] ?? '') ?? -1;
  final detailedCase = Fluid.init<DetailedCase>();
  final result = Fluid.init<VotingResult>();

  @override
  void onReady() {
    super.onReady();
    if (caseId == -1) {
      Get.back();
      logger.w("No caseId provided");
      return;
    }

    loadCase(caseId);
  }

  void loadCase(int caseId) async {
    detailedCase.updateAsync(() => stortinget.getDetailedCase(caseId));
  }
}

class DetailedCaseView extends GetView<DetailedCaseViewController> {
  const DetailedCaseView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DetailedCaseViewController());

    return StandardScaffold(
      title: 'Sak ${controller.caseId}',
      body: Loading(
        value: controller.detailedCase,
        builder:
            (c) => ListView(
              children: [
                Text(c.shortTitle, style: Get.textTheme.headlineSmall),
                if (c.title != c.shortTitle)
                  Text(c.title, style: Get.textTheme.bodyMedium),
                Text("Status: ${c.status}"),
                Text("Type: ${c.type}"),
                Text("Henvisning: ${c.referral}"),
                Text("Dokumentgruppe: ${c.documentGroup}"),
                TopicList(topics: c.topics),
                InfoCard.neutral(c.decisionSummary ?? "Ingen beslutning"),
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
                RepresentativeList(representatives: c.caseOrigin.proposers),
                ReferenceList(references: c.publicationReferences),
                RelatedCaseList(cases: c.relatedCases),
                Text("Søkeord: ${c.searchWords.join(', ')}"),
                Text("Vedtakstekst: ${c.decisionText}"),
                VotingList(caseId: controller.caseId),
              ],
            ),
      ),
    );
  }
}
