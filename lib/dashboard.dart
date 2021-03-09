import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:kaffebotapp/Services/api_service.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'package:kaffebotapp/statistic_view.dart';

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
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      numberAnimation = Tween<double>(begin: 0, end: 0.5).animate(
          CurvedAnimation(
              parent: widget.animationController,
              curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    });
  }

  Future<void> fetchBatteryData() async {
    BatteryStatus response = await apiService.getBatteryPercent();
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
      body: Row(
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
            child: connectPage(),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 32),
              child: temperatureDashboardBody()
            ),
          )
        ],
      ),
    );
  }

  Widget connectPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          'IRobot Admin Data',
          style: Theme.of(context).textTheme.headline3,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget controlPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Control page',
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
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
                onPressed: () {
                  if (_pageController.hasClients) {
                    _pageController.animateToPage(1,
                        duration: pageDuration(), curve: pageAnimationCurve());
                  }
                })
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

  Widget temperatureDashboardBody() {
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
    if(batteryStatus!=null){
      return true;
    } else {
      await fetchBatteryData();
      return true;
    }
  }
}
