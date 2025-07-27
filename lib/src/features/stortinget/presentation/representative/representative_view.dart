import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/components/attribute_list.dart';
import 'package:innsikt/src/components/standard_scaffold.dart';
import 'package:innsikt/src/features/fluid/domain/fluid.dart';
import 'package:innsikt/src/features/fluid/presentation/loading.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/picture_size.dart';
import 'package:innsikt/src/features/stortinget/domain/representative/representative.dart';
import 'package:innsikt/src/utils/extensions/date.dart';
import 'package:innsikt/src/utils/extensions/getx.dart';
import 'package:innsikt/src/utils/extensions/units.dart';
import 'package:logger/logger.dart';

class RepresentativeViewController extends GetxController {
  final logger = Logger();

  final representative = Fluid.init<Representative>();

  @override
  void onReady() {
    final representative = Get.arguments?['representative'];
    
    if (representative is Representative) {
      this.representative.value = Fluid.success(representative);
    } else {
      final representativeId = int.parse(Get.parameters['representativeId'] ?? '');
      throw Exception("Unimplemented fetch of rep by id");
      this.representative.value = Fluid.err("Womp");
      // this.representative.updateAsync(stortinget.getRep);
    }

    super.onReady();
  }

  String profileUrl(Representative representative) {
    return stortinget.getProfileUrl(
      personId: representative.id,
      size: PictureSize.medium,
      defaultPicture: true,
    );
  }
}



class RepresentativeView extends GetView<RepresentativeViewController> {
  const RepresentativeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RepresentativeViewController());

    return Loading(
      value: controller.representative,
      builder:
          (representative) => StandardScaffold(
            title: representative.fullName,
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Image(
                          image: NetworkImage(
                            controller.profileUrl(representative),
                          ),
                        ),
                        Image.asset(
                          representative.party.getPartyImagePath(),
                          width: 50,
                        ),
                      ],
                    ),
                    Flexible(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(1.unit),
                          child: AttributeList(
                            attributes: [
                              Attribute(
                                name: "Født",
                                value:
                                    "${representative.birthDate.prettyDate} (${representative.age} år)",
                                icon: Icons.cake_rounded,
                              ),
                              if (representative.isDeceased)
                                Attribute(
                                  name: "Død",
                                  value: representative.deathDate!.prettyDate,
                                  icon: Icons.church_rounded,
                                ),
                              Attribute(
                                name: "Kjønn",
                                value: representative.gender.toString(),
                                icon: Icons.wc_rounded,
                              ),
                              Attribute(
                                name: "Fylke",
                                value: representative.county.name,
                                icon: Icons.location_on_rounded,
                              ),
                              Attribute(
                                name: "Vara",
                                value: representative.isVara ? "Ja" : "Nei",
                                icon: Icons.gavel,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
