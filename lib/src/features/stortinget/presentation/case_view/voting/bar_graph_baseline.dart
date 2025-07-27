import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

class GraphBarSection {
  final String label;
  final int amount;
  final Color color;

  const GraphBarSection({
    required this.label,
    required this.amount,
    required this.color,
  });
}

typedef GraphBar = List<GraphBarSection>;

class GraphData {
  final List<String> titles;
  final List<GraphBar> bars;

  const GraphData({required this.titles, required this.bars});

  static GraphData plain({required List<String> titles, required GraphBar bars}) {
    return GraphData(bars: bars.map((bar) => [bar]).toList(), titles: titles);
  }

  static GraphData empty() => GraphData(titles: [], bars: []);
}

class BarGraphBaseline extends StatelessWidget {
  final GraphData? graphData;
  final int? maxAmount;
  final double width;
  final double spacing;
  final bool vertical;
  final double labelSize;

  const BarGraphBaseline({
    super.key,
    this.graphData,
    this.maxAmount,
    this.width = 20,
    this.spacing = 10,
    this.vertical = false,
    this.labelSize = 40,
  });

  Widget getTitlesWidget(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= graphData!.titles.length) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      space: 2,
      meta: meta,
      angle: vertical ? 0 : -pi / 6,
      child: Text("${graphData!.titles[index]}  "),
    );
  }

  BarTooltipItem getTooltipItem(
    BarChartGroupData _,
    int groupIndex,
    BarChartRodData _,
    int rodIndex,
  ) {
    final section = graphData!.bars[groupIndex][rodIndex];
    return BarTooltipItem("${section.label} (${section.amount})", TextStyle());
  }

  Color getTooltipColor(BarChartGroupData _) {
    return const Color(0xFFFFFFFF);
  }

  List<BarChartGroupData> generateBarGroups() {
    return graphData!.bars.indexed.map((bar) {
      final (i, sections) = bar;
      var sum = 0.0;

      return BarChartGroupData(
        x: i,
        groupVertically: true,
        barRods:
            sections.indexed.map((s) {
              final (j, section) = s;
              final fromY = sum;
              final toY = sum + section.amount;
              sum = toY;

              return BarChartRodData(
                fromY: fromY,
                toY: toY,
                color: section.color,
                width: width,
                borderRadius: BorderRadius.zero,
                // rodStackItems: not used, because it does not allow
                // for hovering specific sections
              );
            }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (graphData == null) {
      return const SizedBox.shrink();
    }
    return BarChart(
      BarChartData(
        rotationQuarterTurns: vertical ? 1 : 0,
        maxY: maxAmount?.toDouble(),
        groupsSpace: spacing,
        alignment: BarChartAlignment.start,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getTitlesWidget,
              reservedSize: labelSize
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: getTooltipItem,
            getTooltipColor: getTooltipColor,
          ),
        ),
        barGroups: generateBarGroups(),
      ),
    );
  }
}
