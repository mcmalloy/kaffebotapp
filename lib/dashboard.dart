import 'package:flutter/material.dart';
import 'package:kaffebotapp/Services/api_service.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'package:kaffebotapp/statistic_view.dart';

class MyHomePage extends StatefulWidget {
  final AnimationController animationController;
  MyHomePage({Key key, this.title,this.animationController}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _showDashBoard = false;
  ApiService apiService = ApiService();
  Animation numberAnimation;

  PageController _pageController = PageController(
    initialPage: 0
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      numberAnimation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
          parent: widget.animationController,
          curve:
          Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
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
           child:  Padding(
             padding: EdgeInsets.only(left: 32,right: 32, bottom: 512),
             child: temperatureDashboardBody(),
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
        Text(
          'You have pushed the button this many times:',
          style: Theme.of(context).textTheme.headline3,
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
                  var b = await apiService.getLocalTemperature();
                  if (_pageController.hasClients) {
                    _pageController.animateToPage(0,
                        duration: pageDuration(), curve: pageAnimationCurve());
                  }
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
          return StatisticView(
            animation: numberAnimation,
            animationController: widget.animationController,
            closedInViktor: "Lukkede aftaler fra fasit",
            completedTasksNumber: 12,
            closedInFasit: "Lukkede aftaler fra viktor",
            remainingTasksNumber: 4,
          );
        }
      },
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

}
