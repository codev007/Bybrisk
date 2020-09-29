import 'dart:async';
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/style/icons.dart';
import 'package:bybrisk/style/transaction.dart';
import 'package:bybrisk/views/Home.dart';
import 'package:bybrisk/views/chooseCategory.dart';
import 'package:bybrisk/views/letsbegin.dart';
import 'package:bybrisk/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColors;

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  bool isVerified;
  bool isCategory;
  bool isDone;

  _data() async {
    bool islogin = await SharedDatabase().isLogin();
    bool done = await SharedDatabase().getDone();
    bool cate = await SharedDatabase().getCategory();
    setState(() {
      isDone = done;
      isVerified = islogin;
      isCategory = cate;
    });
    if (isDone != null) {
      if (isVerified) {
        if (isDone) {
          if (isCategory) {
            Timer(
                Duration(seconds: 2),
                () => Navigator.of(context)
                    .pushReplacement(FadeRouteBuilder(page: Home())));
          } else {
            Timer(
                Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(
                    FadeRouteBuilder(page: BusinessCategory())));
          }
        } else {
          Timer(
              Duration(seconds: 2),
              () => Navigator.of(context)
                  .pushReplacement(FadeRouteBuilder(page: SignUp())));
        }
      } else {
        Timer(
            Duration(seconds: 2),
            () => Navigator.of(context)
                .pushReplacement(FadeRouteBuilder(page: LetsBegin())));
      }
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.of(context)
              .pushReplacement(FadeRouteBuilder(page: LetsBegin())));
    }
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              height: 100.0,
              child: Image.asset(
                BybriskIcon().logo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
