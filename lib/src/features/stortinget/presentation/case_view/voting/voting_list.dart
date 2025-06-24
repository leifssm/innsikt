import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting.dart';

class VotingListController extends GetxController {
  final Votings votings;

  VotingListController(this.votings);

}

class VotingList extends GetView<VotingListController> {
  final Votings votings;
  const VotingList({super.key, required this.votings});
  
  @override
  Widget build(BuildContext context) {
    Get.put(VotingListController(votings));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.votings.caseVotings.length, // Replace with actual item count
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Voting Item $index'), // Replace with actual data
          
        );
      },
    );
  }
}