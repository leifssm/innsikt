import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_progress.dart';
import 'package:innsikt/src/utils/extensions/units.dart';
import 'package:timelines_plus/timelines_plus.dart';

class CaseProgressTimeline extends StatelessWidget {
  final CaseProgress progress;

  const CaseProgressTimeline({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      builder: TimelineTileBuilder.connected(
        contentsBuilder: (_, i) {
          final step = progress.progressList[i];
          return Padding(
            padding: EdgeInsets.all(1.halfUnit),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "${step.name} - ", style: Get.textTheme.bodyMedium),
                  TextSpan(text: step.id, style: Get.textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
        nodePositionBuilder: (_, _) => 0,
        connectorBuilder:
            (_, _, _) => SolidLineConnector(color: Color(0xFFFF0000)),
        indicatorBuilder:
            (_, _) => OutlinedDotIndicator(
              color: Get.theme.colorScheme.surface,
              backgroundColor: Color(0xFFFF0000),
            ),
        itemCount: progress.progressList.length,
      ),
    );

  }
}
