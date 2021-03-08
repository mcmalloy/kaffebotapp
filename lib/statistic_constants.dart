import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

class StatisticConstants{

  static LinearGradient darkBlueGradient = LinearGradient(colors: [
    HexColor('#87A0E5'),
    HexColor('#87A0E5').withOpacity(0.9),
  ]);

  static BoxDecoration lightBlueBar = BoxDecoration(
    color: HexColor('#87A0E5').withOpacity(0.2),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  );

  static LinearGradient darkRedGradient = LinearGradient(colors: [
    HexColor('#F56E98')
        .withOpacity(0.1),
    HexColor('#F56E98'),
  ]);

  static BoxDecoration lightRedBar = BoxDecoration(
      color: HexColor('#F56E98').withOpacity(0.2),
      borderRadius: BorderRadius.all(Radius.circular(4.0)));


  static LinearGradient darkYellowgradient = LinearGradient(colors: [
    HexColor('#F1B440')
        .withOpacity(0.1),
    HexColor('#F1B440'),
  ]);

  static BoxDecoration lightYellowbar = BoxDecoration(
    color: HexColor('#F1B440')
        .withOpacity(0.2),
    borderRadius: BorderRadius.all(
        Radius.circular(4.0)),
  );

  static LinearGradient greenTaskGradientTheme = LinearGradient(colors: [
  HexColor('#80e27e')
      .withOpacity(0.1),
  HexColor('#087f23'),
  ]);

  static LinearGradient orangeTaskGradientTheme = LinearGradient(colors: [
    HexColor('#ffa726')
        .withOpacity(0.1),
    HexColor('#ff9800'),
  ]);
}

