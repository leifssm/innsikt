import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/picture_size.dart';
import 'package:innsikt/src/features/stortinget/domain/representative/representative.dart';
import 'package:innsikt/src/utils/widget_mapper.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/views/routes.dart';

class RepresentativeListController extends GetxController {
  final List<Representative> representatives;
  RepresentativeListController(this.representatives);

  getProfileUrl(Representative rep) {
    return stortinget.getProfileUrl(
      personId: rep.id,
      size: PictureSize.medium,
      defaultPicture: true,
    );
  }
}

class RepresentativeList extends GetView<RepresentativeListController> {
  final List<Representative> representatives;
  const RepresentativeList({super.key, required this.representatives});

  @override
  Widget build(BuildContext context) {
    Get.put(RepresentativeListController(representatives));

    return WidgetMapper.col(controller.representatives, (rep) {
      return ListTile(
        title: Text('${rep.firstName} ${rep.lastName}'),
        subtitle: Text(
          '${rep.party.id} - ${rep.isVara ? "Vara" : "Ordinær"} - ${rep.county.name} - ${rep.gender}',
        ),
        leading: CircleAvatar(
          foregroundImage: NetworkImage(controller.getProfileUrl(rep)),
        ),
        onTap: () => Routes.goToRepresentativeRoute(rep),
      );
    });
  }
}
