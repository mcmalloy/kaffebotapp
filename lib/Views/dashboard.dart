import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:kaffebotapp/Services/api_service.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'file:///C:/Users/Mark/StudioProjects/kaffebotapp/lib/Views/statistic_view.dart';
import 'package:kaffebotapp/Views/movement_widgets.dart';

class MyHomePage extends StatefulWidget {
  final AnimationController animationController;
  MyHomePage({Key key, this.title, this.animationController}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _showDashBoard = false;
  ApiService apiService = ApiService();
  Animation numberAnimation;
  BatteryStatus batteryStatus;
  bool _isForward = false;
  bool _isTurningLeft = false;
  bool _isTurningRight = false;
  bool _isReversing = false;
  MovementWidgets customWidgets = MovementWidgets();
  StreamController<String> streamController = StreamController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //streamController.stream.asBroadcastStream();
    //streamController.stream.asBroadcastStream(onListen: (messages) => print(messages));
    streamController.stream.listen((messages) => print(messages));
    setState(() {
      numberAnimation = Tween<double>(begin: 0, end: 0.5).animate(
          CurvedAnimation(
              parent: widget.animationController,
              curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    });
  }

  void dispose() {
    print("Closing stream");
    streamController.close();
    super.dispose();
  }

  void newMovementCommand(String message) {
    final duration = Duration(seconds: 2);
    Timer.periodic(duration, (Timer t) => streamController.add(message));
  }

  Future<void> fetchBatteryData() async {
    //BatteryStatus response = await apiService.getBatteryPercent();
    BatteryStatus response = new BatteryStatus(76.4, 4.94, 1.21);
    setState(() {
      print("setting batteryPercent to: ${response.batteryPercentage}");
      batteryStatus = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            widget.title,
            style: TextStyle(color: CustomColors.discordBlue),
          ),
        ),
        body: dashboardBody());
  }

  Widget dashboardBody() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        setState(() {
          keyboardInterpreter(event);
        });
      },
      autofocus: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
              height: double.infinity,
              width: _showDashBoard ? 310 : 70,
              color: CustomColors.discordDashboardGrey,
              duration: Duration(milliseconds: 400),
              child: dashBoardChildren()),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      'IRobot Admin Data',
                      style: Theme.of(context).textTheme.headline3,
                      maxLines: 1,
                    ),
                  ],
                ),
                keyboardUI()
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
                padding:
                    EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 32),
                child: robotStatusWidget()),
          )
        ],
      ),
    );
  }

  Widget dashBoardChildren() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 6),
          children: [
            IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 800),
                  child: _showDashBoard
                      ? Icon(Icons.wifi, color: Colors.green.withOpacity(0.7))
                      : Icon(
                          Icons.wifi_off_outlined,
                          color: Colors.red.withOpacity(0.7),
                        ),
                ),
                iconSize: 40,
                onPressed: () async {
                  fetchBatteryData();
                }),
            IconButton(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                icon: Icon(
                  Icons.settings,
                  color: CustomColors.discordBlue,
                ),
                iconSize: 40,
                onPressed: () {})
          ],
        ),
        CircleAvatar(
          maxRadius: 20,
          backgroundColor: CustomColors.discordBlue,
          child: Icon(
            Icons.add,
            size: 40,
            color: CustomColors.discordDashboardGrey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
        )
      ],
    );
  }

  Duration pageDuration() {
    return Duration(milliseconds: 600);
  }

  Cubic pageAnimationCurve() {
    return Curves.easeInOut;
  }

  Widget robotStatusWidget() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          widget.animationController.forward();
          return StatusView(
            batteryStatus: batteryStatus,
            animation: numberAnimation,
            animationController: widget.animationController,
          );
        }
      },
    );
  }

  Future<bool> getData() async {
    if (batteryStatus != null) {
      return true;
    } else {
      await fetchBatteryData();
      return true;
    }
  }

  Widget keyCap(bool isPressed, String keyCapLetter) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: isPressed
              ? CustomColors.discordBlue.withOpacity(0.7)
              : CustomColors.discordDark,
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        keyCapLetter,
        textAlign: TextAlign.center,
        style: isPressed
            ? customWidgets.highlightMovement()
            : customWidgets.defaultHighlight(),
      ),
    );
  }

  Widget keyboardUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: keyCapPadding(),
          child: keyCap(_isForward, "W"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: keyCapPadding(),
              child: keyCap(_isTurningLeft, "A"),
            ),
            Padding(padding: keyCapPadding(), child: keyCap(_isReversing, "S")),
            Padding(
                padding: keyCapPadding(), child: keyCap(_isTurningRight, "D")),
          ],
        )
      ],
    );
  }

  EdgeInsets keyCapPadding() {
    return EdgeInsets.symmetric(horizontal: 6, vertical: 4);
  }

  void keyboardInterpreter(RawKeyEvent event) {
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      streamController.sink.done;
      resetMovementBool();
      if (event.logicalKey.keyLabel.toUpperCase() == "W") {
        setState(() {
          _isForward = true;
        });
        streamController.sink.add("Moving Forward");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "A") {
        setState(() {
          _isTurningLeft = true;
        });
        streamController.sink.add("Turning Left");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "S") {
        setState(() {
          _isReversing = true;
        });
        streamController.sink.add("Reversing");

      } else if (event.logicalKey.keyLabel.toUpperCase() == "D") {
        setState(() {
          _isTurningRight = true;
        });
        streamController.sink.add("Turning Right");
      }
    } else if (event.runtimeType.toString() == 'RawKeyUpEvent') {
      streamController.sink.done;
      if (event.logicalKey.keyLabel.toUpperCase() == "W") {
        setState(() {
          _isForward = false;
        });
        print("Braking forward");
       } else if (event.logicalKey.keyLabel.toUpperCase() == "A") {
        setState(() {
          _isTurningLeft = false;
        });
        print("Braking left");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "S") {
        setState(() {
          _isReversing = false;
        });
        print("Stop Reversing");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "D") {
        setState(() {
          _isTurningRight = false;
        });
        print("Braking Right");
      }
    }
  }

  void resetMovementBool() {
    setState(() {
      _isForward = false;
      _isTurningRight = false;
      _isTurningLeft = false;
      _isReversing = false;
    });
  }
}
