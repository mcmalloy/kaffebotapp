import 'package:flutter/material.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';

class MovementWidgets {
  TextStyle highlightMovement() {
    return TextStyle(
        fontSize: 16,
        color: CustomColors.discordDashboardGrey);
  }

  TextStyle defaultHighlight() {
    return TextStyle(
        fontSize: 16,
        color: CustomColors.discordBlue);
  }
}
