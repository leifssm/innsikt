import 'package:flutter/material.dart';
import 'package:innsikt/src/utils/extensions/units.dart';

class InfoCard {
  static Card _createCard(String message, IconData icon, [Color? fontColor, Color? bgColor]) {
    return Card(
      color: bgColor,
      child: Padding(
        padding: EdgeInsets.all(1.unit),
        child: Row(
          spacing: 1.unit,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fontColor?.withAlpha(150)),
            Expanded(child: Text(message, style: TextStyle(color: fontColor))),
          ],
        ),
      ),
    );
  }

  static Card neutral(String message) {
    return _createCard(message, Icons.info_outline);
  }

  static Card info(String message) {
    return _createCard(message, Icons.info, Colors.white, Colors.blue);
  }

  static Card warning(String message) {
    return _createCard(message, Icons.warning_rounded, Colors.white, Colors.yellow);
  }

  static Card error(String message) {
    return _createCard(message, Icons.error, Colors.white, Colors.red);
  }

  static Card success(String message) {
    return _createCard(message, Icons.check_circle, Colors.white, Colors.green);
  }
}
