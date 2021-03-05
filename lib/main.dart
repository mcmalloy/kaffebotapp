import 'package:flutter/material.dart';
import 'package:kaffebotapp/Utils/custom_colors.dart';
import 'package:kaffebotapp/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App Title',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          accentColor: CustomColors.discordDashboardGrey, // EXAMPLE: TopBar
          backgroundColor: CustomColors.discordBackgroundGrey, // EXAMPLE: Background
          buttonColor: CustomColors.discordWhite,
          cardColor: CustomColors.discordBlue,
          textTheme:
              TextTheme(headline2: TextStyle(color: CustomColors.discordBlue), headline3: TextStyle(color: CustomColors.discordBlue), ),
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          title: "Kaffebot Kontrol Panel",
        ));
  }
}
