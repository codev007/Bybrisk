import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/beans/Delivery.dart';
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk/beans/Dates.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:bybrisk/style/string.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isFound = false;
  String _selectedValue;
  final now = DateTime.now();
  var dayFormat = DateFormat('dd/MM/yyyy');
  var bottomFormate = DateFormat('dd MMMM yyyy');
  DatePickerController _controller = DatePickerController();
  var dateList = List<Dates>();
  var deliveriesList = List<DeliveryPojo>();
  String businessID;

  _isExist() async {
    print(DateTime.now().toLocal().toString());
    String tempBusinessID = await SharedDatabase().getBusinessID();
    setState(() {
      isLoading = true;
      businessID = tempBusinessID;
    });
    this._fetchDeliveryDatesFromDatabase();
  }

  @override
  void initState() {
    _isExist();
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
          "History",
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: BybriskDimen().title),
        ),
      ),
      bottomNavigationBar: _fetchDatesBar(),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : isFound
              ? Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 250.0,
                          width: 300.0,
                          child: FlareActor(
                            "assets/animation/empty.flr",
                            animation: "empty",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                          alignment: Alignment.center,
                          child: Text(
                            BybrickString().deliverynotfound,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: Bybriskfont().large,
                                color: CustomColor.BybriskColor.textSecondary,
                                fontSize: BybriskDimen().exlarge),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: deliveriesList.length,
                  itemBuilder: (BuildContext contex, int index) {
                    return _deliveryContainerDesign(deliveriesList[index]);
                  }),
    );
  }

  _deliveryContainerDesign(DeliveryPojo deliveryPojo) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Text(
              deliveryPojo.orderId,
              style: BybriskDesign().drawerListText(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(deliveryPojo.address + ", " + deliveryPojo.pincode),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Text(
                    deliveryPojo.ago,
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Spacer(),
                Container(
                  padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Text(
                    deliveryPojo.status == "1"
                        ? "Pending"
                        : deliveryPojo.status == "2"
                            ? "Picked"
                            : deliveryPojo.status == "4"
                                ? "Delivered"
                                : "Shipping",
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

  _fetchDatesBar() {
    return Container(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: dateList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedValue == dateList[index].date
                      ? CustomColor.BybriskColor.primaryColor
                      : Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  onTap: () async {
                    setState(() {
                      _selectedValue = dateList[index].date;
                      isLoading = true;
                    });
                    _fetchDeliveries(_selectedValue);
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${dateList[index].date}',
                        style: TextStyle(
                          color: _selectedValue == dateList[index].date
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _fetchDeliveryDatesFromDatabase() async {
    try {
      Map<String, dynamic> jsondat = {"businessID": businessID};
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.post(mApiController().fetchDeliveryDates,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          dateList = (json.decode(response.body) as List)
              .map((data) => new Dates.fromJson(data))
              .toList();
          if (dateList.length > 0) {
            _selectedValue = dateList[0].date;
            _fetchDeliveries(_selectedValue);
            isFound = false;
          } else {
            isFound = true;
            isLoading = false;
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchDeliveryDatesFromDatabase();
    }
  }

  _fetchDeliveries(String date) async {
    try {
      Map<String, dynamic> jsondat = {"id": businessID, "date": date};
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.post(mApiController().fetchDeliveries,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          deliveriesList = (json.decode(response.body) as List)
              .map((data) => new DeliveryPojo.fromJson(data))
              .toList();
          isLoading = false;
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchDeliveryDatesFromDatabase();
    }
  }
}
