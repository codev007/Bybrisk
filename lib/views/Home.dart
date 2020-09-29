import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/beans/Delivery.dart';
import 'package:bybrisk/beans/Pincodes.dart';
import 'package:bybrisk/beans/Subscription.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/views/addDelivery.dart';
import 'package:bybrisk/views/drawer/faqs.dart';
import 'package:bybrisk/views/drawer/feedback.dart';
import 'package:bybrisk/views/drawer/subscribtionHistory.dart';
import 'package:bybrisk/views/login.dart';
import 'package:bybrisk/views/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:bybrisk/style/string.dart';
import 'package:bybrisk/style/transaction.dart';
import 'package:bybrisk/views/deliveries.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var dayFormat = DateFormat('dd MMMM yyyy');
  var dateFormat = DateFormat('yyyy/MM/dd');
  var timeFormate = DateFormat('HH:mm:ss');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isFound = true;
  bool isAvailable = false;
  String businessID;
  String planID;
  String businessName;
  String businessEmail;
  String messageText;
  String businessPincode;
  String businessMobile;
  var deliveriesList = List<DeliveryPojo>();
  var pincodeList = List<Pincodes>();
  var pincodeTemp = List<String>();
  var uuid = Uuid();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _messageText = "Waiting for message...";
  _isExipred() async {
    setState(() {
      isLoading = true;
    });
    String bID = await SharedDatabase().getBusinessID();
    String bname = await SharedDatabase().getBusinessname();
    String bemail = await SharedDatabase().getEmail();
    String pin = await SharedDatabase().getPincode();
    String mobi = await SharedDatabase().getMobile();

    setState(() {
      businessPincode = pin;
      businessName = bname;
      businessEmail = bemail;
      businessID = bID;
      businessMobile = mobi;
      print("SharedDatabase : " + businessName + businessEmail + businessID);
      if (isAvailable) {
        _fetchDeliveriesFormThedatabase();
      } else {
        _checkAvailability(businessPincode);
      }
    });
    _firebaseMessaging.subscribeToTopic(businessMobile);
  }

  @override
  void initState() {
    setState(() {
      messageText = BybrickString().adddelivery;
    });
    _isExipred();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print(_messageText);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print(_messageText);
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print('$token');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "BUSINESS NAME",
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
                Container(
                  child: Text(
                    businessName,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: CustomColor.BybriskColor.primaryColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Business email",
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
                Container(
                  child: Text(
                    businessEmail,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            )),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text(
                'Profile',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                Navigator.of(context).push(FadeRouteBuilder(page: Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.graphic_eq),
              title: Text(
                'History',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                Navigator.of(context).push(FadeRouteBuilder(page: Delivery()));
              },
            ),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text(
                'Rate us',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.sentiment_satisfied),
              title: Text(
                'Feedback',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                Navigator.of(context).push(FadeRouteBuilder(page: FeedBack()));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline),
              title: Text(
                'FAQ',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                Navigator.of(context).push(FadeRouteBuilder(page: FaqScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text(
                'Terms and Conditions',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                'Privacy Policy',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Log out',
                style: BybriskDesign().drawerListText(),
              ),
              onTap: () {
                _auth.signOut();
                SharedDatabase().userLogout();
                _auth.signOut();
                _firebaseMessaging.unsubscribeFromTopic(businessMobile);
                Navigator.of(context)
                    .pushReplacement(FadeRouteBuilder(page: Login()));
              },
            ),
          ],
        ),
      ),
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
        actions: <Widget>[
          IconButton(
            tooltip: "History",
            icon: Icon(
              Icons.history,
              color: CustomColor.BybriskColor.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).push(FadeRouteBuilder(page: Delivery()));
            },
          )
        ],
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
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 250.0,
                        child: FlareActor(
                          "assets/animation/delivery.flr",
                          animation: "delivery",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        alignment: Alignment.center,
                        child: Text(
                          messageText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: Bybriskfont().large,
                              color: CustomColor.BybriskColor.textSecondary,
                              fontSize: BybriskDimen().exlarge),
                        ),
                      )
                    ],
                  ),
                ))
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: deliveriesList.length,
                      itemBuilder: (BuildContext contex, int index) {
                        return _deliveryContainerDesign(deliveriesList[index]);
                      }),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          icon: Icon(Icons.add),
          onPressed: () async {
            if (!isLoading) {
              if (isAvailable) {
                final result = await Navigator.of(context)
                    .push(FadeRouteBuilder(page: AddDelivery(pincodeTemp)));
                if (result != null) {
                  if (result) {
                    _refresh();
                  }
                }
              } else {
                BybriskDesign().showInSnackBar(
                    "Delivery not available for " + businessPincode,
                    _scaffoldKey);
              }
            }
          },
          label: Text("Add new delivery")),
    );
  }

  Future<void> _refresh() async {
    //  _fetchData();
    setState(() {
      isLoading = true;
      isFound = false;
      deliveriesList.clear();
    });
    _isExipred();
  }

  _deliveryContainerDesign(DeliveryPojo deliveryPojo) {
    return InkWell(
      onTap: () {
        _deliveryDetails(deliveryPojo);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                deliveryPojo.orderId,
                style:
                    TextStyle(fontFamily: Bybriskfont().large, fontSize: 18.0),
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
      ),
    );
  }

  _fetchDeliveriesFormThedatabase() async {
    try {
      Map<String, dynamic> jsondat = {
        "id": businessID,
        "date": dateFormat.format(DateTime.now().toLocal()).toString()
      };
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.post(mApiController().fetchDeliveries,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          deliveriesList = (json.decode(response.body) as List)
              .map((data) => new DeliveryPojo.fromJson(data))
              .toList();
          if (deliveriesList.length > 0) {
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
      _isExipred();
    }
  }

  _deliveryDetails(DeliveryPojo deliveryPojo) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (contex) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 18.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Delivery Details",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Destination Address",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.address,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Destination Pincode",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.pincode,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Contact Number",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.mobile,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Delivery Type",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.cOD == "PP"
                                  ? "Prepaid"
                                  : "Cash on delivery : ₹" + deliveryPojo.cOD,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Delivery Status",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      top: 5.0,
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 7.0),
                                  child: Container(
                                    child: StepProgressIndicator(
                                      totalSteps: 4,
                                      currentStep:
                                          int.parse(deliveryPojo.status),
                                      direction: Axis.vertical,
                                      size: 3.0,
                                      selectedColor:
                                          CustomColor.BybriskColor.primaryColor,
                                      unselectedColor: Colors.black12,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 7.0),
                                        child: Text(
                                          "Request sent",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                deliveryPojo.status == "1"
                                                    ? Bybriskfont().large
                                                    : Bybriskfont().small,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 7.0),
                                        child: Text(
                                          "Order Picked",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                deliveryPojo.status == "2"
                                                    ? Bybriskfont().large
                                                    : Bybriskfont().small,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 7.0),
                                        child: Text(
                                          "Shipping...",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                deliveryPojo.status == "3"
                                                    ? Bybriskfont().large
                                                    : Bybriskfont().small,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 7.0),
                                        child: Text(
                                          "Delivered Successfully",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                deliveryPojo.status == "4"
                                                    ? Bybriskfont().large
                                                    : Bybriskfont().small,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 20.0,
                          )
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  _checkAvailability(String pincode) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.get(mApiController().isDeliveryAvailable,
          headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          pincodeList = (json.decode(response.body) as List)
              .map((data) => new Pincodes.fromJson(data))
              .toList();
          print(pincodeList);
          if (pincodeList.length > 0) {
            for (int i = 0; i < pincodeList.length; i++) {
              pincodeTemp.add(pincodeList[i].pincode);
            }
            if (pincodeTemp.contains(businessPincode)) {
              isAvailable = true;
              _isExipred();
            } else {
              isLoading = false;
              isAvailable = false;
              messageText =
                  "Bybrisk service\nNot available\nFor " + businessPincode;
            }
          } else {
            isLoading = false;
            isAvailable = false;
            messageText =
                "Bybrisk service\nNot available\nFor " + businessPincode;
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _isExipred();
    }
  }
}
