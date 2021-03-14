import 'package:flutter/material.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';

class RobotMovement extends StatefulWidget {
  final RawKeyEvent event;
  const RobotMovement({ Key key, this.event}) : super(key: key);

  @override
  _RobotMovementState createState() => _RobotMovementState(event);
}

class _RobotMovementState extends State<RobotMovement> {
  RawKeyEvent event;
  _RobotMovementState(this.event);

  bool _isForward = false;
  bool _isTurningLeft = false;
  bool _isTurningRight = false;
  bool _isReversing = false;

  void keyboardInterpreter(RawKeyEvent event) {
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      if (event.logicalKey.keyLabel.toUpperCase() == "W") {
        setState(() {
          _isForward = true;
        });
        print("Moving forward");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "A") {
        print("Turning left");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "S") {
        print("Reversing");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "D") {
        print("Turning Right");
      }
    }
  }

  TextStyle highlightMovement() {
    return TextStyle(
        backgroundColor: CustomColors.discordBlue,
        color: CustomColors.discordDashboardGrey);
  }

  TextStyle defaultHighlight() {
    return TextStyle(
        backgroundColor: CustomColors.discordBackgroundGrey,
        color: CustomColors.discordBlue);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event){
          keyboardInterpreter(event);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "W",
                style: _isForward ? highlightMovement() : defaultHighlight(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text("A",
                      style: _isTurningLeft
                          ? highlightMovement()
                          : defaultHighlight()),
                ),
                Container(
                  child: Text("S",
                      style: _isReversing
                          ? highlightMovement()
                          : defaultHighlight()),
                ),
                Container(
                  child: Text("D",
                      style: _isTurningRight
                          ? highlightMovement()
                          : defaultHighlight()),
                )
              ],
            )
          ],
        ));
  }
}
