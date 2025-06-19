import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/related_case.dart';
import 'package:innsikt/src/utils/widget_mapper.dart';
import 'package:innsikt/src/views/routes.dart';

class RelatedCaseItem extends StatelessWidget {
  final RelatedCase relatedCase;
  const RelatedCaseItem({super.key, required this.relatedCase});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.toNamed(
          Routes.getDetailedRoute(),
          parameters: {'caseId': relatedCase.caseId.toString()},
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.insert_drive_file_outlined),
      title: Text(relatedCase.shortTitle),
    );
  }
}

class RelatedCaseList extends StatelessWidget {
  final List<RelatedCase> cases;

  const RelatedCaseList({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    return WidgetMapper.col(cases, (c) => RelatedCaseItem(relatedCase: c));
  }
}
