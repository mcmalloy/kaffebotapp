import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:kaffebotapp/Services/api_service.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'package:kaffebotapp/Views/movement_widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'statistic_view.dart';

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
  bool _isConnectedToRobot = false;

  MovementWidgets customWidgets = MovementWidgets();
  StreamController<String> streamController = StreamController();
  //String webSocketURL = "127.0.0.1:8765"; //LOCAL
  String movementDuration = "1.9";
  String webSocketURL = "192.168.0.86:8765";
  IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://192.168.0.86:8765");
  TextEditingController _urlController = TextEditingController();

  String startLocation = "Charging Point";
  String endLocation = "Cafe";

  @override
  void initState() {
    super.initState();
    setState(() {
      numberAnimation = Tween<double>(begin: 0, end: 0.5).animate(
          CurvedAnimation(
              parent: widget.animationController,
              curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    });
  }

  void refreshAnimation(double newValue){ 
    double _currentAnimationValue = widget.animationController.value;
    print("current animation value: $_currentAnimationValue");
    //widget.animationController = widget.animationController.reverse();
    //widget.animationController.reset();
    setState(() {
      //batteryStatus = new BatteryStatus(70, 4.94, 1.21);
    });
    widget.animationController.animateBack(0.70,duration: Duration(seconds: 2), curve: Curves.easeInOutCubic);
  }

  Future<void> attemptStreamConnection() {
    String status;
    setState(() {
      channel = IOWebSocketChannel.connect("ws://$webSocketURL");
    });
    try {
      channel.sink.add("Test Connection");
      channel.sink.add("21"); // 2.2 seconds about 1 meter or about 0.455m/s. Distance to M2.80 = 8.6 meters
      channel.stream.listen((event) {
        print("Status from server: $event");
        status = event;
      });
      channel.sink.done;
      setState(() {
        _isConnectedToRobot = true;
      });
    } catch (e) {
      print("Websocket error occurred: $e");
      setState(() {
        _isConnectedToRobot = false;
      });
    }
  }

  Future<void> initStream() async {
    String command = "";
    channel.stream.listen((event) {
      // Python requires to send a confirmation, we ignore it
      print("Sending stream: $event");
      channel.sink.add(event);
    });
  }

  void dispose() {
    print("Closing stream");
    streamController.close();
    channel.sink.close();
    super.dispose();
  }

  Future<void> fetchBatteryData() async {
    //BatteryStatus response = await apiService.getBatteryPercent();
    BatteryStatus response = new BatteryStatus(76.4, 4.94, 1.21);
    setState(() {
      print("setting batteryPercent to: ${response.batteryPercentage}");
      batteryStatus = response;
    });
    refreshAnimation(response.batteryPercentage);
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
              child: keyboardUI(),)
          ],
        ));
  }

  Widget connectionStatusWidget() {
    return Positioned(
      top: 32,
      left: 102,
      child: Container(
          padding: EdgeInsets.only(left: 12),
          width: 400,
          height: 200,
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
                "Connection status to Roomba: $_isConnectedToRobot ",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.discordBlue)),
              ),
              Text(
                "Current IP address: $webSocketURL",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.discordBlue)),
              ),
              InkWell(
                onTap: (){
                  attemptStreamConnection();
                },
                child: Container(
                  height: 50,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: CustomColors.discordBlue,
                  ),
                  child: Center(
                    child: Text("Test Connection",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.discordBackgroundGrey))),
                  ),
                ),
              ),

            ],
          )),
    );
  }

  Widget drivingStatusWidget(){
    return Positioned(
      bottom: 32,
      left: 102,
      child: Container(
          padding: EdgeInsets.only(left: 12),
          width: 400,
          height: 200,
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
                "Movement status: idle",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.discordBlue)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: InkWell(
                      onTap: (){
                        attemptStreamConnection();
                      },
                      child: Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CustomColors.discordBlue,
                        ),
                        child: Center(
                          child: Text("Drive home",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.discordBackgroundGrey))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: (){
                        attemptStreamConnection();
                      },
                      child: Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CustomColors.discordBlue,
                        ),
                        child: Center(
                          child: Text("Drive Cafe",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.discordBackgroundGrey))),
                        ),
                      ),
                    ),
                  )
                ],
              )

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
                  bool responseStatus = await apiService.initializePythonClient(webSocketURL);
                  setState(() {
                    _isConnectedToRobot = responseStatus;
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
      padding: EdgeInsets.only(right: 32, top: 32),
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

  void keyboardInterpreter(RawKeyEvent event) {
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      streamController.sink.done;
      channel.sink.done;
      //initStream();
      resetMovementBool();
      if (event.logicalKey.keyLabel.toUpperCase() == "W") {
        setState(() {
          _isForward = true;
        });
        streamController.sink.add("Moving Forward");
        channel.sink.add("Moving Forward");
        channel.sink.add(movementDuration);

      } else if (event.logicalKey.keyLabel.toUpperCase() == "A") {
        setState(() {
          _isTurningLeft = true;
        });
        streamController.sink.add("Turning Left");
        channel.sink.add("Turning Left");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "S") {
        setState(() {
          _isReversing = true;
        });
        streamController.sink.add("Reversing");
        channel.sink.add("Reversing");
        channel.sink.add(movementDuration);
      } else if (event.logicalKey.keyLabel.toUpperCase() == "D") {
        setState(() {
          _isTurningRight = true;
        });
        streamController.sink.add("Turning Right");
        channel.sink.add("Turning Right");
      } else if (event.logicalKey.keyLabel.toUpperCase() == "R"){
        fetchBatteryData();
      }
    } else if (event.runtimeType.toString() == 'RawKeyUpEvent') {
      streamController.sink.done;
      channel.sink.done;
      //initStream();
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
