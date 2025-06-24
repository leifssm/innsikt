import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/party.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/representative_voting_result.dart';
import 'package:innsikt/src/utils/extensions/units.dart';

class BarDataSection {
  final int amount;
  final Color color;
  final String label;

  const BarDataSection({
    required this.amount,
    required this.color,
    required this.label,
  });
}

typedef BarDataBar = List<BarDataSection>;

class VotingRatioController extends GetxController {
  final List<RepresentativeVotingResult> representativeVotingResult;
  final forVotes = <RepresentativeVotingResult>[];
  final againstVotes = <RepresentativeVotingResult>[];
  final absentVotes = <RepresentativeVotingResult>[];

  final rodData = <BarDataBar>[].obs;
  final rods = <BarChartGroupData>[].obs;
  final titles = <String>[].obs;

  final spacing = 20.0.obs;
  final barWidth = 50.0;
  double get totalWidth =>
      (rodData.length * (barWidth + spacing.value)) - spacing.value;

  VotingRatioController(this.representativeVotingResult) {
    for (var result in representativeVotingResult) {
      switch (result.vote) {
        case VoteType.forVote:
          forVotes.add(result);
          break;
        case VoteType.against:
          againstVotes.add(result);
          break;
        case VoteType.absent:
          absentVotes.add(result);
          break;
      }
    }
  }

  int get totalYes => forVotes.length;
  int get totalNo => againstVotes.length;
  int get totalAbsent => absentVotes.length;
  int get totalVotes => totalYes + totalNo + totalAbsent;

  List<BarChartRodData> _barData(List<BarDataSection> sections) {
    var sum = 0.0;

    var i = 0;
    return sections.map((s) {
      i++;
      final data = BarChartRodData(
        fromY: sum,
        toY: sum + s.amount,
        color: s.color,
        width: 40,
        borderRadius:
            (i == sections.length)
                ? const BorderRadius.vertical(top: Radius.circular(4))
                : BorderRadius.only(),
        // rodStackItems: [BarChartRodStackItem(sum, sum + s.amount, s.color)],
      );
      sum += s.amount;
      return data;
    }).toList()
    // .reversed.toList()
    ;
  }

  List<BarDataSection> _groupByParty(List<RepresentativeVotingResult> results) {
    final grouped = <Party, int>{};

    for (var result in results) {
      grouped.update(
        result.representative.party,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final partyList =
        grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return partyList
        .map(
          (p) => BarDataSection(
            label: p.key.name,
            color: p.key.color,
            amount: p.value,
          ),
        )
        .toList();
  }

  void _setRods(List<List<BarDataSection>> newRods) {
    var i = 0;
    rodData.assignAll(newRods);

    rods.assignAll(
      newRods.map(
        (r) => BarChartGroupData(
          x: i++,
          groupVertically: true,
          barRods: _barData(r),
        ),
      ),
    );
  }

  void sortByVotes() {
    titles.assignAll([
      'For ($totalYes)',
      'Imot ($totalNo)',
      'Borte ($totalAbsent)',
    ]);
    _setRods([
      _groupByParty(forVotes),
      _groupByParty(againstVotes),
      _groupByParty(absentVotes),
    ]);
  }

  // void sortByParty() {
  //   titles.assignAll([
  //     'For ($totalYes)',
  //     'Imot ($totalNo)',
  //     'Borte ($totalAbsent)',
  //   ]);
  //   _setRods([
  //     _groupByParty(forVotes),
  //     _groupByParty(againstVotes),
  //     _groupByParty(absentVotes),
  //   ]);
  // }

  BarTooltipItem? getTooltipItem(
    BarChartGroupData group,
    int groupIndex,
    BarChartRodData rod,
    int rodIndex,
  ) {
    final section = rodData[groupIndex][rodIndex];
    return BarTooltipItem("${section.label} (${section.amount})", TextStyle());
  }
}

class VotingRatio extends GetView<VotingRatioController> {
  final List<RepresentativeVotingResult> representativeVotingResult;
  const VotingRatio({super.key, required this.representativeVotingResult});

  @override
  Widget build(BuildContext context) {
    Get.put(VotingRatioController(representativeVotingResult));

    controller.sortByVotes();

    return SizedBox(
      width: controller.totalWidth,
      height: 150,
      child: Obx(
        () => BarChart(
          BarChartData(
            alignment: BarChartAlignment.start,
            groupsSpace: controller.spacing.value,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget:
                      (i, meta) => SideTitleWidget(
                        space: 0,
                        meta: meta,
                        child: Obx(() => Text(controller.titles[i.toInt()])),
                      ),
                ),
              ),
            ),
            barGroups: controller.rods,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: controller.getTooltipItem,
                getTooltipColor: (_) => const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
