import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';

class MovementWidgets {
  TextStyle highlightMovement() {
    return GoogleFonts.montserrat(
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CustomColors.discordDashboardGrey));
  }

  TextStyle defaultHighlight() {
    return GoogleFonts.montserrat(
        textStyle: TextStyle(
            fontSize: 16,
            color: CustomColors.discordBlue));
  }

  TextStyle montSerratHighlight() {
    return GoogleFonts.montserrat(
        textStyle: TextStyle(
            fontSize: 16,
            color: CustomColors.discordBlue));
  }
}
