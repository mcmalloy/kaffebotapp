import 'package:flutter/material.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showDashBoard = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
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
                onPressed: () {}),
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
        Padding(padding: EdgeInsets.symmetric(vertical: 30),)
      ],
    );
  }
}
