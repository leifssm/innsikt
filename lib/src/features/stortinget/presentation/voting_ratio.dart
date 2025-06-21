import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/party.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/representative_voting_result.dart';

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
  final forVotes = <RepresentativeVotingResult>[];
  final againstVotes = <RepresentativeVotingResult>[];
  final absentVotes = <RepresentativeVotingResult>[];

  final rodData = <BarDataBar>[].obs;
  final rods = <BarChartGroupData>[].obs;

  VotingRatioController(
    List<RepresentativeVotingResult> representativeVotingResult,
  ) {
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

  BarChartRodData _barData(List<BarDataSection> sections) {
    var sum = 0.0;
    final rodStackItems =
        sections.map((s) {
          final item = BarChartRodStackItem(sum, sum + s.amount, s.color);
          sum += s.amount;
          return item;
        }).toList();

    return BarChartRodData(
      toY: sum,
      color: sections.firstOrNull?.color ?? const Color(0xFF000000),
      width: 40,
      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      rodStackItems: rodStackItems,
    );
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
      newRods.map((r) => BarChartGroupData(x: i++, barRods: [_barData(r)])),
    );
  }

  void sortByVotes() {
    _setRods([
      _groupByParty(forVotes),
      _groupByParty(againstVotes),
      _groupByParty(absentVotes),
    ]);
  }

  BarTooltipItem? getTooltipItem(
    BarChartGroupData group,
    int groupIndex,
    BarChartRodData rod,
    int rodIndex,
  ) {
    print ("$groupIndex $rodIndex");
    return BarTooltipItem(rodData[groupIndex][rodIndex].label, TextStyle());
  }
}

class VotingRatio extends GetView<VotingRatioController> {
  final List<RepresentativeVotingResult> representativeVotingResult;
  const VotingRatio({super.key, required this.representativeVotingResult});

  @override
  Widget build(BuildContext context) {
    Get.put(VotingRatioController(representativeVotingResult));

    controller.sortByVotes();

    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: BarChart(
          BarChartData(
            maxY: 169,
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
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
