import 'package:flutter/material.dart';
import 'dart:io';
import 'package:kaffebotapp/Utils/custom_colors.dart';

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
  /*
  WindowsFrame(
          active: Platform.isWindows,
          border: Border.all(color: CustomColors.discordDashboardGrey),
          child: MyHomePage(
            title: "Kaffebot Kontrol Panel",
          ),
        )
   */
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 2500), vsync: this);
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

