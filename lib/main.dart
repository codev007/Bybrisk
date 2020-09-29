import 'package:bybrisk/views/flashscreen.dart';
import 'package:bybrisk/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColors;

void main() async {
  // then render the app on screen
  runApp(MyApp());
}

final routes = {
  '/': (BuildContext context) => new FlashScreen(),
  '/signup': (BuildContext context) => new SignUp(),

};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      //    routes: routes,
      routes: routes,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: CustomColors.BybriskColor.white,
        accentColor: CustomColors.BybriskColor.primaryColor,
        primaryColorDark: CustomColors.BybriskColor.primaryColor,
        primaryIconTheme: Theme.of(context)
            .primaryIconTheme
            .copyWith(color: CustomColors.BybriskColor.primaryColor),
      ),
    );
  }
}
