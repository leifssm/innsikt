import 'package:flutter/widgets.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/voting/bar_graph_baseline.dart';

class SimpleVotingRatio extends StatelessWidget {
  final int forVotes;
  final int againstVotes;
  final int absentVotes;
  final titles = const <String>['For', 'Imot', 'Borte'];
  final bool vertical;

  const SimpleVotingRatio({
    super.key,
    required this.forVotes,
    required this.againstVotes,
    required this.absentVotes,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (forVotes < 0 || againstVotes < 0 || absentVotes < 0) {
      return const SizedBox.shrink();
    }
    return BarGraphBaseline(
      vertical: vertical,
      // spacing: 5,
      graphData: GraphData.plain(
        titles: titles,
        bars: [
          GraphBarSection(
            label: titles[0],
            amount: forVotes,
            color: const Color(0xFF4CAF50),
          ),
          GraphBarSection(
            label: titles[1],
            amount: againstVotes,
            color: const Color(0xFFF44336),
          ),
          GraphBarSection(
            label: titles[2],
            amount: absentVotes,
            color: const Color(0xFF9E9E9E),
          ),
        ],
      ),
      // maxAmount: (forVotes + againstVotes + absentVotes),
    );
  }
}
