import 'package:flutter/material.dart';

class WidgetMapper {
  static Column col<T>(List<T> list, Widget Function(T) mapper) {
    return Column(
      children: list.map(mapper).toList(),
    );
  }

  static Row row<T>(List<T> list, Widget Function(T) mapper) {
    return Row(children: list.map(mapper).toList());
  }
}