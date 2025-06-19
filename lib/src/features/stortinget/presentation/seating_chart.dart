import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SeatingChartController extends GetxController {
  final width = 400.0;
  final seats = <ScatterSpot>[].obs;

  @override
  void onInit() {
    super.onInit();

    const amounts = [9, 18, 18, 26, 30, 34, 34];
    const radius = 5.0;
    const scaling = 0.2;

    final seatsTemp = <ScatterSpot>[];

    for (var i = 0; i < amounts.length; i++) {
      final amount = amounts[i];
      for (var j = 0; j < amount; j++) {
        seatsTemp.add(
          ScatterSpot(
            (i * scaling + 1) * cos(pi * (j / (amount - 1))).toPrecision(2),
            (i * scaling + 1) * sin(pi * (j / (amount - 1))).toPrecision(2),
            dotPainter: FlDotCirclePainter(radius: radius),
          ),
        );
      }
    }

    seats.assignAll(seatsTemp);
  }
}

class SeatingChart extends GetView<SeatingChartController> {
  const SeatingChart({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SeatingChartController());
    return SizedBox(
      width: controller.width,
      height: controller.width / 2,
      child: Obx(
        () => ScatterChart(
          ScatterChartData(
            scatterSpots: controller.seats,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
          ),
        ),
      ),
    );
  }
}
