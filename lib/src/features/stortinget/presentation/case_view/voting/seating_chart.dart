import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/party.dart'
    show partyColorFromId;
import 'package:innsikt/src/features/stortinget/domain/representative/representative.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/representative_voting_result.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/seating_chart_spots.dart';
import 'package:innsikt/src/views/routes.dart';

class SeatingChartController extends GetxController {
  final width = 400.0.obs;
  double get height => width / 2;
  double get nodeSize => width.value / 55;

  final seats = <ScatterSpot>[].obs;
  late final List<Representative>? representatives;
  late final List<RepresentativeVotingResult>? representativeVotingResult;

  SeatingChartController({
    List<Representative>? representatives,
    List<RepresentativeVotingResult>? representativeVotingResult,
  }) {
    this.representatives =
        representatives?.toList()?..sort((a, b) => a.party.compareTo(b.party));

    this.representativeVotingResult =
        representativeVotingResult?.toList()?..sort(
          (a, b) => a.representative.party.compareTo(b.representative.party),
        );
  }

  @override
  void onReady() {
    super.onReady();

    createSpots();
  }

  void createSpots() {
    var i = 0;
    seats.assignAll(
      generatedSeats.map((seat) {
        final (x, y) = seat;

        FlDotPainter painter = switch (getRepresentativeVote(i)) {
          VoteType.forVote => FlDotCirclePainter(
            radius: nodeSize,
            color: getSeatColor(i),
          ),
          VoteType.against => FlDotCrossPainter(
            size: nodeSize * 1.3,
            width: nodeSize * 0.5,
            color: getSeatColor(i),
          ),
          VoteType.absent => FlDotCirclePainter(
            radius: nodeSize,
            color: getSeatColor(i).withAlpha(50),
          ),
        };

        return ScatterSpot(
          x,
          y,
          dotPainter: painter,
          renderPriority: i++, // Bootleg indexing
        );
      }),
    );
  }

  Representative? getRepresentative(int index) {
    if (representativeVotingResult != null) {
      return representativeVotingResult![index].representative;
    } else if (representatives != null) {
      return representatives![index];
    }
    return null; // Default if no representatives or results are available
  }

  VoteType getRepresentativeVote(int index) {
    if (representativeVotingResult == null) return VoteType.forVote;
    return representativeVotingResult![index].vote;
  }

  Color getSeatColor(int index) {
    return partyColorFromId(getRepresentative(index)?.party.id);
  }

  ScatterTooltipItem? getTooltipItems(ScatterSpot spot) {
    final rep = getRepresentative(spot.renderPriority);
    if (rep == null) return null;

    return ScatterTooltipItem('${rep.fullName} (${rep.party.id})');
  }

  MouseCursor mouseCursorResolver(
    FlTouchEvent _,
    ScatterTouchResponse? response,
  ) {
    if (response?.touchedSpot == null) return SystemMouseCursors.basic;
    return SystemMouseCursors.click;
  }

  void seatSelectionCallback(
    FlTouchEvent event,
    ScatterTouchResponse? response,
  ) {
    if (event is! FlTapUpEvent) return;

    final index = response?.touchedSpot?.spot.renderPriority;
    if (index == null) return;
    final rep = getRepresentative(index);
    if (rep == null) return;
    Routes.goToRepresentativeRoute(rep);
  }
}

class SeatingChart extends GetView<SeatingChartController> {
  final List<Representative>? representatives;
  final List<RepresentativeVotingResult>? representativeVotingResult;
  final bool disableInteraction;
  const SeatingChart({
    super.key,
    this.representatives,
    this.representativeVotingResult,
    this.disableInteraction = false,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(
      SeatingChartController(
        representatives: representatives,
        representativeVotingResult: representativeVotingResult,
      ),
    );

    return AspectRatio(
      aspectRatio: 2,
      child: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth.isFinite) {
            controller.width.value = constraints.maxWidth;
          }

          return Obx(() {
            return ScatterChart(
              ScatterChartData(
                scatterSpots: controller.seats.toList(),
                scatterTouchData:
                    disableInteraction
                        ? ScatterTouchData(
                          enabled: false,
                          mouseCursorResolver: (_, _) => MouseCursor.defer,
                        )
                        : ScatterTouchData(
                          touchTooltipData: ScatterTouchTooltipData(
                            getTooltipItems: controller.getTooltipItems,
                          ),
                          mouseCursorResolver: controller.mouseCursorResolver,
                          touchCallback: controller.seatSelectionCallback,
                        ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                minX: -4,
                maxX: 4,
                minY: -0.2,
                maxY: 4,
              ),
            );
          });
        },
      ),
    );
  }
}
