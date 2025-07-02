import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class GraphBarSection {
  final String label;
  final int amount;
  final Color color;

  const GraphBarSection({
    required this.amount,
    required this.color,
    required this.label,
  });
}

typedef GraphBar = List<GraphBarSection>;

class GraphData {
  final List<GraphBar> bars;
  final List<String> titles;

  const GraphData({required this.bars, required this.titles});

  static plain({required GraphBar bars, required List<String> titles}) {
    return GraphData(bars: bars.map((bar) => [bar]).toList(), titles: titles);
  }
}

class BarGraphBaseline extends StatelessWidget {
  final GraphData? graphData;
  final int? maxAmount;
  final double width;
  final double spacing;
  const BarGraphBaseline({
    super.key,
    this.graphData,
    this.maxAmount,
    this.width = 20,
    this.spacing = 10,
  });

  Widget getTitlesWidget(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= graphData!.titles.length) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      space: 0,
      meta: meta,
      angle: -pi / 6,
      child: Text(graphData!.titles[index]),
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
