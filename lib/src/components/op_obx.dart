// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Optional Obx
Widget OpObx(dynamic Function() builder) {
  return Obx(() {
    final widget = builder();
    return widget is Widget ? widget : SizedBox.shrink();
  });
}

/// Show widget conditionally
Widget Show(
  Rx<bool> show, {
  bool negate = false,
  required Widget Function() builder,
}) {
  return Obx(() {
    if (show.value ^ negate) {
      return builder();
    }
    return SizedBox.shrink();
  });
}
