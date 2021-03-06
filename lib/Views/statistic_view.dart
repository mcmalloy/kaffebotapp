import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kaffebotapp/Model/battery_status.dart';
import 'dart:math' as math;

import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kaffebotapp/Utils/statistic_constants.dart';

class StatusView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final BatteryStatus batteryStatus;
  const StatusView(
      {Key key, this.animationController, this.animation, this.batteryStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return batteryStatusContainers();
        });
  }

  Widget batteryStatusContainers() {
    return Column(
      children: [
        Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: CustomColors.discordDashboardGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(68.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: CustomColors.discordDashboardGrey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: batteryPercentage()),
        SizedBox(
          height: 140,
        ),
        Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: CustomColors.discordDashboardGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(68.0),
                  topRight: Radius.circular(8.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: CustomColors.discordDashboardGrey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: voltageAndCurrent())
      ],
    );
  }

  Widget batteryPercentage() {
    return Padding(
        padding:
            const EdgeInsets.only(right: 16, left: 16, top: 32, bottom: 32),
        child: Row(
          children: [
            AutoSizeText(
              "Battery Level ",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  letterSpacing: -0.2,
                  color: CustomColors.discordBlue),
            ),
            Center(child: batteryPercentCircle()),
          ],
        ));
  }

  Widget voltageAndCurrent() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 32),
      child: Row(
        children: <Widget>[
          bottomStatisticOverview(
              HexColor('#F1B440').withOpacity(0.9),
              "Battery Voltage",
              batteryStatus.batteryVoltage,
              StatisticConstants.darkYellowgradient,
              StatisticConstants.lightYellowbar,
              CrossAxisAlignment.start),
          bottomStatisticOverview(
              CustomColors.discordBlue,
              "Battery Current",
              batteryStatus.batteryCurrent,
              StatisticConstants.darkBlueGradient,
              StatisticConstants.lightBlueBar,
              CrossAxisAlignment.end),
        ],
      ),
    );
  }

  Widget leftStatisticContainer(
      Color verticalBarColor, String closedFrom, Color iconColor) {
    return Row(
      children: <Widget>[
        Container(
          //height: 48,
          height: 48 * animationController.value,
          width: 8,
          decoration: BoxDecoration(
            color: verticalBarColor,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 2),
                child: Text(
                  "$closedFrom",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.1,
                    color: CustomColors.discordDashboardGrey.withOpacity(0.5),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 28,
                    height: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 3),
                    child: Text(
                      '${(12 * animationController.value).toInt()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget batteryPercentCircle() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: CustomColors.discordDashboardGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(100.0),
              ),
              border: new Border.all(
                  width: 4, color: CustomColors.discordBlue.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeText(
                  //'${(batteryPercent * animationController.value).toInt()}%',
                  '${(batteryStatus.batteryPercent * animationController.value).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 26,
                    letterSpacing: 0.0,
                    color: CustomColors.discordBlue,
                  ),
                  maxLines: 1,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomPaint(
            painter: CurvePainter(
              colors: [
                HexColor("#8A98E8"),
                CustomColors.discordBlue,
              ],
              angle:
                  ((animationController.value * batteryStatus.batteryPercent) /
                          100) *
                      360,
            ),
            child: SizedBox(
              width: 108,
              height: 108,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomStatisticOverview(
      Color textColor,
      String type,
      double powerValue,
      LinearGradient thickGradient,
      BoxDecoration horizontalBarGradient,
      CrossAxisAlignment calignment) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: calignment,
      children: <Widget>[
        AutoSizeText(
          type,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.2,
              color: textColor),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 12,
            width: 100,
            decoration: horizontalBarGradient,
            child: Row(
              children: <Widget>[
                Container(
                  width: (85 - animation.value),
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: thickGradient,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                )
              ],
            ),
          ),
        ),
        AutoSizeText(
          type.contains("Voltage")
              ? "${batteryStatus.batteryVoltage}V"
              : "${-batteryStatus.batteryCurrent*1000}mA",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.2,
              color: textColor),
        )
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shadowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shadowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shadowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(
            center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shadowPaint);

    shadowPaint.color = Colors.grey.withOpacity(0.3);
    shadowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(
            center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shadowPaint);

    shadowPaint.color = Colors.grey.withOpacity(0.2);
    shadowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(
            center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shadowPaint);

    shadowPaint.color = Colors.grey.withOpacity(0.1);
    shadowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(
            center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shadowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var radians = (math.pi / 180) * degree;
    return radians;
  }
}
