import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:kaffebotapp/Model/odometry.dart';
import 'package:kaffebotapp/Services/api_service.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'package:kaffebotapp/Views/movement_widgets.dart';
import 'statistic_view.dart';

enum containerShapeCurve { TopRight, TopLeft, BottomRight, BottomLeft }

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
  BatteryStatus batteryStatus = BatteryStatus(0, 0, 0, 0, 0, 1);
  bool _isForward = false;
  bool _isTurningLeft = false;
  bool _isTurningRight = false;
  bool _isReversing = false;
  bool _isConnectedToRobot = false;

  DateTime _lastPostRequest;

  Odometry currentVelocity = Odometry(0, 0);

  MovementWidgets customWidgets = MovementWidgets();
  String startLocation = "Charging Point";
  String endLocation = "Cafe";
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBatteryData();
    setState(() {
      numberAnimation = Tween<double>(begin: 0, end: 0.5).animate(
          CurvedAnimation(
              parent: widget.animationController,
              curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    });
  }

  void dispose() {
    super.dispose();
  }

  Future<void> fetchBatteryData() async {
    BatteryStatus response = await apiService.fetchBatteryData();
    //BatteryStatus response = new BatteryStatus(73.4, 4.94, 1.21);
    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        batteryStatus = response;
        widget.animationController.reset();
        numberAnimation = Tween<double>(begin: 0, end: 0.5).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
        widget.animationController.forward();
      });
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
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                    padding: EdgeInsets.only(left: 0),
                    height: double.infinity,
                    width: _showDashBoard ? 310 : 70,
                    color: CustomColors.discordDashboardGrey,
                    duration: Duration(milliseconds: 400),
                    child: dashBoardIcons()),
                robotStatusWidget(),
              ],
            ),
            connectionStatusWidget(),
            drivingStatusWidget(),
            Positioned(
              left: 560,
              bottom: 32,
              child: keyboardUI(),
            )
          ],
        ));
  }

  Widget connectionStatusWidget() {
    return Positioned(
      top: 32,
      left: 102,
      child: Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          width: 300,
          height: 120,
          decoration: BoxDecoration(
            color: CustomColors.discordDashboardGrey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: CustomColors.discordDashboardGrey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){

                },
                child: Container(
                  height: 50,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: CustomColors.discordBlue,
                  ),
                  child: Center(
                    child: Text("Drive Route",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.discordBackgroundGrey))),
                  ),
                ),
              ),

            ],
          )),
    );
  }



  Widget drivingStatusWidget() {
    return Positioned(
      bottom: 32,
      left: 102,
      child: Container(
          padding: EdgeInsets.only(left: 12),
          width: 300,
          height: 120,
          decoration: BoxDecoration(
            color: CustomColors.discordDashboardGrey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: CustomColors.discordDashboardGrey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Velocity_x: ${currentVelocity.linearVelocity}",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.discordBlue)),
              ),
              Text(
                "Velocity_angular: ${currentVelocity.turnVelocity}",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.discordBlue)),
              ),
            ],
          )),
    );
  }

  Widget dashBoardIcons() {
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
                  child: _isConnectedToRobot
                      ? Icon(Icons.wifi, color: Colors.green.withOpacity(0.7))
                      : Icon(
                          Icons.wifi_off_outlined,
                          color: Colors.red.withOpacity(0.7),
                        ),
                ),
                iconSize: 40,
                onPressed: () async {
                  //fetchBatteryData();
                  setState(() {
                    _isConnectedToRobot = true;
                  });
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
    return Padding(
      padding: EdgeInsets.only(right: 32, bottom: 32, top: 32),
      child: FutureBuilder<bool>(
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
      ),
    );
  }

  BoxDecoration boxShape(containerShapeCurve shape) {
    return BoxDecoration(
      color: CustomColors.discordDashboardGrey,
      borderRadius: BorderRadius.only(
          topLeft: shape == containerShapeCurve.TopLeft
              ? Radius.circular(68.0)
              : Radius.circular(8.0),
          bottomLeft: shape == containerShapeCurve.BottomLeft
              ? Radius.circular(68.0)
              : Radius.circular(8.0),
          bottomRight: shape == containerShapeCurve.BottomRight
              ? Radius.circular(68.0)
              : Radius.circular(8.0),
          topRight: shape == containerShapeCurve.TopRight
              ? Radius.circular(68.0)
              : Radius.circular(8.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: CustomColors.discordDashboardGrey.withOpacity(0.2),
            offset: Offset(1.1, 1.1),
            blurRadius: 10.0),
      ],
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
      height: 90,
      width: 90,
      decoration: BoxDecoration(
          color: isPressed
              ? CustomColors.discordBlue.withOpacity(0.7)
              : CustomColors.discordDark,
          borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: EdgeInsets.only(top: 24),
        child: Text(
          keyCapLetter,
          textAlign: TextAlign.center,
          style: isPressed
              ? customWidgets.highlightMovement()
              : customWidgets.defaultHighlight(),
        ),
      ),
    );
  }

  Widget keyboardUI() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
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
              Padding(
                  padding: keyCapPadding(), child: keyCap(_isReversing, "S")),
              Padding(
                  padding: keyCapPadding(),
                  child: keyCap(_isTurningRight, "D")),
            ],
          )
        ],
      ),
    );
  }

  EdgeInsets keyCapPadding() {
    return EdgeInsets.symmetric(horizontal: 6, vertical: 4);
  }

  Future<void> moveRobot(String command) async {
    if(_lastPostRequest == null){
      Odometry _currentVelocity = await apiService.postMovement(command);
      _lastPostRequest = DateTime.now();
    }
    int deltaTime = DateTime.now().difference(_lastPostRequest).inMilliseconds;
    //print("Difference in ms: $deltaTime");
    if(deltaTime>=600){
      Odometry _currentVelocity = await apiService.postMovement(command);
      print("Linear Velocity is: ${_currentVelocity.linearVelocity.toString()}");
      print("Angular Velocity is: ${_currentVelocity.turnVelocity.toString()}");
      setState(() {
        currentVelocity = _currentVelocity;
        _lastPostRequest = DateTime.now();
      });
    }
    if(command == "stop"){
      Odometry _currentVelocity = await apiService.postMovement(command);
      setState(() {
        currentVelocity = _currentVelocity;
        _lastPostRequest = DateTime.now();
      });
    }

  }

  void keyboardInterpreter(RawKeyEvent event) {
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      resetMovementBool();
      if (event.logicalKey.keyLabel.toUpperCase() == "W") {
        setState(() {
          _isForward = true;
        });
        moveRobot("forward");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "A") {
        setState(() {
          _isTurningLeft = true;
        });
        moveRobot("left");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "S") {
        setState(() {
          _isReversing = true;
        });
        moveRobot("backwards");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "D") {
        setState(() {
          _isTurningRight = true;
        });
        moveRobot("right");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "R") {
        fetchBatteryData();
      }
    } else if (event.runtimeType.toString() == 'RawKeyUpEvent') {
      moveRobot("stop");
      if (event.logicalKey.keyLabel.toUpperCase() == "W") {
        setState(() {
          _isForward = false;
        });
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
