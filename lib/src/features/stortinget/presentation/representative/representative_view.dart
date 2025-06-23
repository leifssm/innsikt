import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/components/attribute_list.dart';
import 'package:innsikt/src/components/info_card.dart';
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

  // Can be passed to fill with already cached data
  final _representative = Get.arguments?['representative'];
  Representative get representative {
    if (_representative is! Representative) {
      throw StateError(
        "representative argument must be a Representative object",
      );
    }
    return _representative;
  }

  @override
  void onReady() {
    super.onReady();
    if (_representative is! Representative) {
      Get.back();
      logger.e("No representative provided");
      return;
    }
  }
}

class RepresentativeView extends GetView<RepresentativeViewController> {
  const RepresentativeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RepresentativeViewController());

    final profile = getProfileUrl(
      personId: controller.representative.id,
      size: PictureSize.small,
      defaultPicture: true,
    );

    return StandardScaffold(
      title: controller.representative.fullName,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image(image: NetworkImage(profile)),
                  Image.asset(
                    controller.representative.party.getPartyImagePath(),
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
                              "${controller.representative.birthDate.prettyDate} (${controller.representative.age} år)",
                          icon: Icons.cake_rounded,
                        ),
                        if (controller.representative.isDeceased)
                          Attribute(
                            name: "Død",
                            value:
                                controller.representative.deathDate!.prettyDate,
                            icon: Icons.church_rounded,
                          ),
                        Attribute(
                          name: "Kjønn",
                          value: controller.representative.gender.toString(),
                          icon: Icons.wc_rounded,
                        ),
                        Attribute(
                          name: "Fylke",
                          value: controller.representative.county.name,
                          icon: Icons.location_on_rounded,
                        ),
                        Attribute(
                          name: "Vara",
                          value:
                              controller.representative.isVara ? "Ja" : "Nei",
                          icon: Icons.gavel,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(controller.representative.toString()),
        ],
      ),
    );
  }
}
