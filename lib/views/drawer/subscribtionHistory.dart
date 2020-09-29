import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:bybrisk/beans/Subscription.dart';
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Subscriptionhistory extends StatefulWidget {
  @override
  _SubscriptionhistoryState createState() => _SubscriptionhistoryState();
}

class _SubscriptionhistoryState extends State<Subscriptionhistory> {
  var dayFormat = DateFormat('dd MMMM yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String businessID;
  var subscribedPlans = List<Subscription>();
  bool isLoading = true;
  bool isFound = false;
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
      final response = await http.post(mApiController().fetchSubscriptionPlans,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          subscribedPlans = (json.decode(response.body) as List)
              .map((data) => new Subscription.fromJson(data))
              .toList();
          if (subscribedPlans.length > 0) {
            isFound = false;
          } else {
            isFound = true;
          }
          isLoading = false;
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchSubscritionPlansList();
    }
  }

  @override
  void initState() {
    _getData();
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
          : isFound
              ? Center(
                  child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Hmm !\nNo Subscription found\nPlease subscribe our plan\nNow",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: Bybriskfont().large,
                              color: CustomColor.BybriskColor.textSecondary,
                              fontSize: BybriskDimen().exlarge),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          onPressed: () async {

                          },
                          child: Text("View Plans"),
                        ),
                      )
                    ],
                  ),
                ))
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: subscribedPlans.length,
                      itemBuilder: (BuildContext contex, int index) {
                        return _deliveryContainerDesign(subscribedPlans[index]);
                      }),
                ),
    );
  }

  _deliveryContainerDesign(Subscription deliveryPojo) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Text(
              deliveryPojo.name,
              style: TextStyle(fontFamily: Bybriskfont().large, fontSize: 18.0),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              deliveryPojo.status == "A" ? "Currently Active" : "Expired",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 7.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Text(
                    "To : ",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Text(
                    dayFormat
                        .format(DateTime.parse(deliveryPojo.renewalDate))
                        .toString(),
                    style: TextStyle(
                        fontSize: 13.0,
                        color: CustomColor.BybriskColor.primaryColor),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Text(
                    "From : ",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: Text(
                    dayFormat
                        .format(DateTime.parse(deliveryPojo.expiryDate))
                        .toString(),
                    style: TextStyle(
                        fontSize: 13.0,
                        color: CustomColor.BybriskColor.primaryColor),
                  ),
                ),
              ],
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
      isFound = false;
      subscribedPlans.clear();
    });
    _getData();
  }
}
