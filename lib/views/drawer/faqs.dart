import 'package:bybrisk/beans/FaqsPojo.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:bybrisk/beans/Subscription.dart';
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/style/design.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;
  var faqs = List<FaqsPojo>();
  String businessID;

  @override
  void initState() {
    this._getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0.0,
        title: Text(
          "Bybrisk",
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: 20.0),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  itemCount: faqs.length,
                  itemBuilder: (BuildContext contex, int index) {
                    return _deliveryContainerDesign(faqs[index]);
                  }),
            ),
    );
  }

  _deliveryContainerDesign(FaqsPojo deliveryPojo) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Text(
              deliveryPojo.question,
              style: TextStyle(
                  fontFamily: Bybriskfont().large,
                  fontSize: 18.0,
                  color: Colors.grey),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              deliveryPojo.answer,
              style: TextStyle(fontFamily: Bybriskfont().large, fontSize: 18.0),
            ),
          ),
          BybriskDesign().bigSpacer()
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    //  _fetchData();
    setState(() {
      isLoading = true;
      faqs.clear();
    });
    _getData();
  }

  _getData() async {
    String tempID = await SharedDatabase().getBusinessID();
    setState(() {
      businessID = tempID;
    });
    _fetchSubscritionPlansList();
  }

  _fetchSubscritionPlansList() async {
    try {
      Map<String, dynamic> jsondat = {
        "id": businessID,
      };
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.post(mApiController().fetchFaq,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          faqs = (json.decode(response.body) as List)
              .map((data) => new FaqsPojo.fromJson(data))
              .toList();
          isLoading = false;
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchSubscritionPlansList();
    }
  }
}
