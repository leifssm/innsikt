import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_list.dart';
import 'package:innsikt/src/features/stortinget/domain/party_list.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/voting_ratio.dart';
import 'package:innsikt/src/features/stortinget/presentation/infinite_case_view.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';

class HomePageController extends GetxController {
  final title = 'Hello World'.obs;
  final cases = Fluid.loading<CaseList>().obs;
  final parties = Fluid.loading<PartyList>().obs;

  void fetch1() async {
    parties.updateAsync(stortinget.getAllParties);
  }

  String get str1 {
    if (parties.isLoading) return 'Loading...';
    if (parties.isError) return 'Error: ${parties.error}';
    return 'Success: Fetched ${parties.data} sessions';
  }

  void fetch2() async {
    await cases.updateAsync(stortinget.getCases);
  }

  String get str2 {
    if (cases.isLoading) return 'Loading...';
    if (cases.isError) return 'Error: ${cases.error}';
    return 'Success: Fetched ${cases.data} sessions';
  }
}

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    Get.put(StortingetRepository.create());

    return Scaffold(
      body: 
          InfiniteCaseView(
            // cases: controller.cases,
            // onTap: (Case c) async {
            //   final detailedCase = await controller.repository.getDetailedCase(c.id);
            //   Get.to(() => DetailedCaseView(detailedCase: detailedCase));
            // },
          ),
    );
  }
}
