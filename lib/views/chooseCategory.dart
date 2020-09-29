import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/beans/BusinessCategory.dart';
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:bybrisk/style/string.dart';
import 'package:bybrisk/style/transaction.dart';
import 'package:bybrisk/views/Home.dart';
import 'package:bybrisk/views/Success.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BusinessCategory extends StatefulWidget {
  @override
  _BusinessCategoryState createState() => _BusinessCategoryState();
}

class _BusinessCategoryState extends State<BusinessCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var categoryList = List<Category>();
  var selectedCategory = List<String>();
  bool isLoading = true;
  String businessID;
  void getBusinessID() async {
    String temp = await SharedDatabase().getBusinessID();
    setState(() {
      businessID = temp.toString();
    });
    mLoadCategory();
  }

  @override
  void initState() {
    this.getBusinessID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      floatingActionButton: isLoading || selectedCategory.length == 0
          ? Container()
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                mSubmitCategory(selectedCategory);
              },
              icon: Icon(Icons.done),
              label: Text(
                "Finish Setup",
                style: TextStyle(
                    color: CustomColor.BybriskColor.white,
                    fontSize: 16.0,
                    fontFamily: Bybriskfont().large),
              ),
            ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      margin: EdgeInsets.only(top: 50.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        BybrickString().chooseCategory,
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.primaryColor,
                            fontSize: BybriskDimen().exlarge),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new CheckboxListTile(
                          title: new Text(
                            categoryList[index].name,
                            style: TextStyle(fontFamily: Bybriskfont().large),
                          ),
                          onChanged: (bool value) {
                            setState(() {
                              if (value) {
                                selectedCategory.clear();
                                selectedCategory
                                    .add(categoryList[index].id.toString());
                              } else {
                                selectedCategory
                                    .remove(categoryList[index].id.toString());
                              }
                            });
                          },
                          value: selectedCategory
                              .contains(categoryList[index].id.toString()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void mLoadCategory() async {
    try {
      Map<String, dynamic> jsondat = {"id": businessID};
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.post(mApiController().fetchCategory,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          categoryList = (json.decode(response.body) as List)
              .map((data) => new Category.fromJson(data))
              .toList();
          if (categoryList.length > 0) {
            isLoading = false;
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      mLoadCategory();
    }
  }

  void mSubmitCategory(List<String> catList) async {
    try {
      String url = mApiController().submitCategory;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {"id": businessID, "cat": catList};
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setCategory(true);
        Navigator.of(context)
            .pushReplacement(FadeRouteBuilder(page: Success()));
      } else {
        BybriskDesign()
            .showInSnackBar("Problem occurs ! Please try again", _scaffoldKey);
      }
      setState(() {
        isLoading = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection", _scaffoldKey);
    }
  }
}
