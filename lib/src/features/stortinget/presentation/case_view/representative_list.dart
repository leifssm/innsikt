import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/picture_size.dart';
import 'package:innsikt/src/features/stortinget/domain/representative/representative.dart';
import 'package:innsikt/src/utils/widget_mapper.dart';
import 'package:innsikt/src/views/routes.dart';

class RepresentativeList extends StatelessWidget {
  final List<Representative> representatives;
  const RepresentativeList({super.key, required this.representatives});

  @override
  Widget build(BuildContext context) {
    return WidgetMapper.col(representatives, (rep) {
      final profile = getProfileUrl(
        personId: rep.id,
        size: PictureSize.medium,
        defaultPicture: true,
      );

      return ListTile(
        title: Text('${rep.firstName} ${rep.lastName}'),
        subtitle: Text(
          '${rep.party.id} - ${rep.isVara ? "Vara" : "Ordinær"} - ${rep.county.name} - ${rep.gender}',
        ),
        leading: CircleAvatar(foregroundImage: NetworkImage(profile)),
        onTap: () {
          Routes.goToRepresentativeRoute(rep);
        },
      );
    });
  }
}
