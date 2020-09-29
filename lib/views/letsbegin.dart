import 'dart:io';

import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:bybrisk/style/string.dart';
import 'package:bybrisk/style/transaction.dart';
import 'package:bybrisk/views/login.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;

class LetsBegin extends StatefulWidget {
  @override
  _LetsBeginState createState() => _LetsBeginState();
}

class _LetsBeginState extends State<LetsBegin> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
        appBar: null,
        body: Container(
          color: CustomColor.BybriskColor.primaryColor,
          child: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 40.0),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 40),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BybrickString().startQuote,
                          style: TextStyle(
                              fontFamily: Bybriskfont().exsmall,
                              color: CustomColor.BybriskColor.white,
                              fontSize: BybriskDimen().large),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "With",
                          style: TextStyle(
                              fontFamily: Bybriskfont().small,
                              fontSize: BybriskDimen().medium,
                              color: CustomColor.BybriskColor.white),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bybrisk",
                          style: TextStyle(
                              fontFamily: Bybriskfont().large,
                              color: CustomColor.BybriskColor.white,
                              fontSize: BybriskDimen().large),
                        ),
                      ),
                      Container(
                        decoration: BybriskDesign().hollowButtonDesign(),
                        margin: EdgeInsets.only(top: 60.0, bottom: 40.0),
                        child: InkWell(
                          splashColor: CustomColor.BybriskColor.primaryColor,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                FadeRouteBuilder(page: Login()));
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                right: 15.0,
                                left: 15.0),
                            child: Text(
                              "Let's Get Started",
                              style: TextStyle(
                                  color: CustomColor.BybriskColor.white,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
