import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_list.dart';
import 'package:innsikt/src/features/stortinget/domain/case/detailed_case.dart';
import 'package:innsikt/src/features/stortinget/domain/party_list.dart';
import 'package:innsikt/src/utils/fluid.dart';

class HomePageController extends GetxController {
  final title = 'Hello World'.obs;
  final cases = Fluid.loading<CaseList>().obs;
  final parties = Fluid.loading<PartyList>().obs;
  final repository = StortingetRepository.create();

  void fetch1() async {
    parties.updateAsync(repository.getAllParties);
  }

  String get str1 {
    if (parties.isLoading) return 'Loading...';
    if (parties.isError) return 'Error: ${parties.error}';
    return 'Success: Fetched ${parties.data} sessions';
  }

  void fetch2() async {
    await cases.updateAsync(repository.getCases);
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

    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => TextButton(
              onPressed: controller.fetch1,
              child: Text(controller.str1),
            ),
          ),
          Obx(
            () => TextButton(
              onPressed: controller.fetch2,
              child: Text(controller.str2),
            ),
          ),
        ],
      ),
    );
  }
}
