import 'package:flutter/material.dart';
import 'dart:io';
import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'package:desktop_window/desktop_window.dart';

import 'Views/dashboard.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Main();
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with TickerProviderStateMixin {
  AnimationController animationController;
  Size _windowSize;
  double windowWidth = 1280;
  double windowHeight = 720;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setWindowSize();
    animationController = AnimationController(duration: Duration(milliseconds: 2500), vsync: this);
  }

  Future _setWindowSize() async {
    setState(() {
      _windowSize = Size(windowWidth,windowHeight);
    });
    await DesktopWindow.setMinWindowSize(_windowSize);
    await DesktopWindow.setWindowSize(_windowSize);
    await DesktopWindow.setMaxWindowSize(_windowSize);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App Title',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          accentColor: CustomColors.discordDashboardGrey, // EXAMPLE: TopBar
          backgroundColor:
          CustomColors.discordBackgroundGrey, // EXAMPLE: Background
          buttonColor: CustomColors.discordWhite,
          cardColor: CustomColors.discordBlue,
          textTheme: TextTheme(
            headline2: TextStyle(color: CustomColors.discordBlue),
            headline3: TextStyle(color: CustomColors.discordBlue),
          ),
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          animationController: animationController,
          title: "Kaffebot Kontrol Panel",
        ));
  }
}

