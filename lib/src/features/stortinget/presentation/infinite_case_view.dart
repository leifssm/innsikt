import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_list.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:innsikt/src/views/routes.dart';

class InfiniteCaseViewController extends GetxController {
  final cases = Fluid.init<CaseList>();

  @override
  void onReady() {
    super.onReady();
    // Routes.goToDetailedCase(103838);
    fetchCases();
  }

  void fetchCases() async {
    cases.updateAsync(stortinget.getCases);
  }
}

class InfiniteCaseView extends GetView<InfiniteCaseViewController> {
  const InfiniteCaseView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InfiniteCaseViewController());

    final searchWord = "skatt";

    return Loading(
      value: controller.cases,
      builder:
          (cases) => ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cases.cases.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  cases.cases[index].shortTitle,
                  style: TextStyle(height: 1.1),
                ),
                subtitle: Text(
                  'Case ID: ${cases.cases[index].id}\n'
                  'Status: ${cases.cases[index].documentGroup} - ${cases.cases[index].recommendationCode}',
                ),
                tileColor:
                    cases.cases[index].id == 103838
                        ? Colors.blue[300]
                        : null,

                onTap: () {
                  Routes.goToDetailedCase(cases.cases[index].id);
                },
              );
            },
          ),
    );
  }
}
