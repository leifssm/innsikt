import 'package:flutter/material.dart';
import 'package:innsikt/src/features/stortinget/domain/case/case_topic.dart';
import 'package:innsikt/src/utils/extensions/units.dart';

class TopicList extends StatelessWidget {
  final List<CaseTopic> topics;
  const TopicList({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 1.halfUnit,
      runSpacing: 1.halfUnit,
      children: topics.map((t) => Chip(label: Text(t.name))).toList(),
    );
  }
}
