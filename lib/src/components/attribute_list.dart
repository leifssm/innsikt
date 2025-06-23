import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:innsikt/src/utils/extensions/units.dart';
import 'package:innsikt/src/utils/widget_mapper.dart';

class Attribute {
  final String name;
  final String value;
  final IconData? icon;

  const Attribute({required this.name, required this.value, this.icon});
}

class AttributeList extends StatelessWidget {
  final List<Attribute> attributes;
  const AttributeList({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    final hasIcons = attributes.any((attr) => attr.icon != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          attributes
              .map(
                (attribute) => Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 1.quarterUnit,
                  children: [
                    if (hasIcons)
                      attribute.icon != null
                          ? Icon(attribute.icon, size: 1.unit)
                          : Icon(
                            Icons.hide_image_rounded,
                            color: Colors.transparent,
                          ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${attribute.name}: ",
                            style: Get.textTheme.bodyLarge!.apply(
                              fontWeightDelta: 1,
                            ),
                          ),
                          TextSpan(
                            text: attribute.value,
                            style: Get.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }
}
