import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/FirebaseMessagingService.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart' as bybrisk;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddDelivery extends StatefulWidget {
  final List<String> mPincodeList;
  AddDelivery(this.mPincodeList, {Key key}) : super(key: key);
  @override
  _AddDeliveryState createState() => _AddDeliveryState();
}

class _AddDeliveryState extends State<AddDelivery> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Razorpay _razorpay;
  String apiKey = "AIzaSyCl2hdW1gv9Wr_YoJP09U7mz5bCaby2zuw";
  PickResult _pickedLocation;
  //------------ADD DELIVERY DATA INTIALIZATION-------------------
  var dayFormat = DateFormat('dd MMMM yyyy');
  var dateFormat = DateFormat('yyyy/MM/dd');
  var timeFormate = DateFormat('HH:mm:ss');
  String mBusinessPincode;
  TextEditingController _mDeliveryPincode = new TextEditingController();
  TextEditingController _mDeliveryAddress = new TextEditingController();
  String mDeliveryMobile = "";
  String mDeliveryAmount = "PP";
  double mDeliveryWeight = 0.0;
  bool isChecked = false;
  String orderID;
  var uuid = Uuid();
  double lat;
  double lang;
  bool isAdding = true;
  String businessID;
  final bybrisk.Distance distance = new bybrisk.Distance();
  double mDistanceLatitude;
  double mDistanceLongitude;
  String businessName;
  String mobileNumber;
  String mEmail;
  bool isAvailable = true;

  //-------------PAYABBLE AMUNT-----------------------------
  String w;
  var mPayableAmount = 0.0;
  var baseRate = 0;
  var distanceFactor = 0.0;
  var weightFactor = 0.0;
  var payableDistance = 0;
  var weightList = [
    0.5,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];
  //-----------PAYABLE AMOUNT CLOSE--------------------------
  _isExipred() async {
    String bID = await SharedDatabase().getBusinessID();
    double latti = await SharedDatabase().getLatitude();
    double longgi = await SharedDatabase().getLongitude();
    String bname = await SharedDatabase().getBusinessname();
    String mNo = await SharedDatabase().getMobile();
    String emil = await SharedDatabase().getEmail();
    String pcode = await SharedDatabase().getPincode();

    print("Location : " + latti.toString() + longgi.toString());
    setState(() {
      mEmail = emil;
      mobileNumber = mNo;
      businessName = bname;
      businessID = bID;
      mDistanceLatitude = latti;
      mDistanceLongitude = longgi;
      mBusinessPincode = pcode;
    });
    loadBaseRateAndDistanceFactor();
  }

  @override
  void initState() {
    print(widget.mPincodeList);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    this._isExipred();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "+ Add delivery",
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: 20.0),
        ),
      ),
      body: isAdding
          ? Container(
              margin: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                      child: Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: Bybriskfont().small,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        child: TextFormField(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  apiKey: apiKey, // Put YOUR OWN KEY here.
                                  onPlacePicked: (result) async {
                                    setState(() {
                                      _pickedLocation = result;
                                    });
                                    if (_pickedLocation != null) {
                                      Coordinates cord = Coordinates(
                                          _pickedLocation.geometry.location.lat,
                                          _pickedLocation
                                              .geometry.location.lng);
                                      var addresses = await Geocoder.local
                                          .findAddressesFromCoordinates(cord);
                                      var first = addresses.first;
                                      final double km = distance.as(
                                          bybrisk.LengthUnit.Kilometer,
                                          new bybrisk.LatLng(
                                              _pickedLocation
                                                  .geometry.location.lat,
                                              _pickedLocation
                                                  .geometry.location.lng),
                                          new bybrisk.LatLng(mDistanceLatitude,
                                              mDistanceLongitude));

                                      setState(() {
                                        payableDistance = km.round() + 1;
                                        _mDeliveryAddress.text =
                                            _pickedLocation.adrAddress;
                                        _mDeliveryPincode.text =
                                            first.postalCode;
                                        if (widget.mPincodeList
                                            .contains(_mDeliveryPincode.text)) {
                                          isAvailable = true;
                                        } else {
                                          isAvailable = false;
                                        }
                                        lat = _pickedLocation
                                            .geometry.location.lat;
                                        lang = _pickedLocation
                                            .geometry.location.lng;
                                      });
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  initialPosition:
                                      LatLng(-33.8567844, 151.213108),
                                  useCurrentLocation: true,
                                ),
                              ),
                            );
                          },
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          controller: _mDeliveryAddress,
                          obscureText: false,

                          //    validator: Validate().validatePassword,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Address',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                      child: Text(
                        isAvailable
                            ? "Pincode"
                            : "Sorry delivery service not available here !",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: Bybriskfont().small,
                            color: isAvailable ? Colors.black : Colors.red),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        child: TextFormField(
                          enabled: false,
                          //  maxLength: 10,
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          controller: _mDeliveryPincode,
                          obscureText: false,

                          //    validator: Validate().validatePassword,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: '6 digit pincode',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                      child: Text(
                        "Contact number",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: Bybriskfont().small,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        child: TextFormField(
                          //    enabled: !otpVerifing,
                          //  maxLength: 10,
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          //    controller: _mobile,
                          obscureText: false,
                          onChanged: (value) {
                            setState(() {
                              mDeliveryMobile = value;
                            });
                          },
                          //    validator: Validate().validatePassword,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Mobile number',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value;
                                    if (!isChecked) {
                                      mDeliveryAmount = "PP";
                                    }
                                  });
                                }),
                          ),
                          Container(
                            child: Text("Cash on delivery"),
                          )
                        ],
                      ),
                    ),
                    isChecked
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0))),
                              child: TextFormField(
                                //    enabled: !otpVerifing,
                                //  maxLength: 10,
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                //    controller: _mobile,
                                obscureText: false,
                                onChanged: (value) {
                                  setState(() {
                                    mDeliveryAmount = value;
                                  });
                                },
                                //    validator: Validate().validatePassword,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Payment amount',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                      child: Text(
                        "Delivery Weight  (Kg)",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: Bybriskfont().small,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                          "Select Weight",
                          style: TextStyle(color: Colors.grey),
                        ),
                        items: weightList.map((item) {
                          return new DropdownMenuItem(
                            child:
                                new Text("Within " + item.toString() + " kg"),
                            value: item.toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() async {
                            w = newVal;
                            weightFactor = await getWeightFactor(
                                baseRate, double.parse(newVal));
                          });
                        },
                        value: w.toString(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                      child: Text(
                        "Distance from your shop",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: Bybriskfont().small,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        payableDistance.toString() + " Km",
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.textPrimary,
                            fontSize: 20.0),
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        if (_mDeliveryPincode.text.length > 0 &&
                            mDeliveryMobile.length > 0 &&
                            _mDeliveryAddress.text.length > 0 &&
                            mDeliveryAmount.length > 0 &&
                            mDeliveryWeight > 0 &&
                            isAvailable) {
                          setState(() {
                            orderID = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            mPayableAmount = baseRate +
                                payableDistance * distanceFactor +
                                weightFactor * mDeliveryWeight;
                          });
                          openCheckout();
                        } else {
                          BybriskDesign().showInSnackBar(
                              "Something missing !", _scaffoldKey);
                        }
                      },
                      label: Text(
                        "Pay ₹" +
                            (baseRate +
                                    payableDistance * distanceFactor +
                                    weightFactor * mDeliveryWeight)
                                .toString() +
                            " for Add Delivery",
                        style: TextStyle(
                            color: CustomColor.BybriskColor.white,
                            fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_zBqDq4uuqqThIE',
      'amount': mPayableAmount * 100,
      'name': businessName,
      'description': 'Payment',
      'prefill': {'contact': mobileNumber, 'email': mEmail},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  _postDeliveryToDatabse(
      String id,
      String orderid,
      String pincode,
      String address,
      String cod,
      String date,
      String mobile,
      String time) async {
    try {
      String url = mApiController().addDelivery;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {
        "id": id,
        "order_id": orderid,
        "pincode": pincode,
        "address": address,
        "COD": cod,
        "date": date,
        "mobile": mobile,
        "time": time,
        "business_id": businessID,
        "lat": lat,
        "lang": lang
      };
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      print(body.toString());
      if (!body['error']) {
        setState(() {
          isAdding = false;
        });
        sendAndRetrieveMessage(
            "New order added ", orderid, ["admin", mBusinessPincode]);
        Navigator.of(context).pop(true);
      }
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection !", _scaffoldKey);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    BybriskDesign().showInSnackBar("Please Wait ... ", _scaffoldKey);
    // Do something when payment succeeds
    setState(() {
      isAdding = true;
    });
    _postDeliveryToDatabse(
        uuid.v1().toString(),
        orderID,
        _mDeliveryPincode.text,
        _mDeliveryAddress.text,
        mDeliveryAmount,
        dateFormat.format(DateTime.now().toLocal()).toString(),
        mDeliveryMobile,
        timeFormate.format(DateTime.now().toLocal()).toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message);
    BybriskDesign().showInSnackBar(
        "Problem occurs ! Please try again " + response.message, _scaffoldKey);
    setState(() {
      isAdding = false;
    });
    // Removes all listeners
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    BybriskDesign().showInSnackBar(
        "Problem occurs ! Please try again " + response.walletName,
        _scaffoldKey);
    setState(() {
      isAdding = false;
    });
    // Removes all listeners
  }
  /*
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PlacePicker(apiKey)));
    setState(() {
      _pickedLocation = result;
    });
    // Handle the result in your way
    print(result);
  }
  */

  double getWeightFactor(int baseRate, double weight) {
    //----------PHARMACY---------------------------
    if (baseRate == 27) {
      if (weight == 0.5 || weight == 1) {
        return 1.5;
      } else if (weight == 2 || weight == 3 || weight == 4 || weight == 5) {
        return 1.2;
      } else {
        return 0.8;
      }
    }
    //----------GROCERY-------------------------
    if (baseRate == 21) {
      if (weight > 0.5) {
        return 0.8;
      } else {
        return 0.0;
      }
    }

    //-----------DRY FRUITES----------------------
    if (baseRate == 29) {
      return 3.0;
    }

    //-----------ELECTRONICS CALCULATOR------------------------
    if (baseRate == 31) {
      if (weight == 0.5 || weight == 1) {
        return 2.0;
      }
      if (weight == 2) {
        return 3.0;
      }
      if (weight == 3) {
        return 3.0;
      }
      if (weight == 4) {
        return 4.0;
      }
      if (weight == 5) {
        return 4.0;
      }
      if (weight == 6) {
        return 5;
      }
      if (weight == 7) {
        return 5;
      }
      if (weight == 8) {
        return 5.5;
      }
      if (weight == 9) {
        return 6;
      }
      if (weight == 10 || weight == 11) {
        return 6.5;
      }
      if (weight == 12 || weight == 13) {
        return 7.0;
      }
      if (weight == 14 || weight == 15) {
        return 7.5;
      }
      if (weight == 16 || weight == 17) {
        return 8.0;
      }
      if (weight == 18 || weight == 19) {
        return 8.5;
      }
      if (weight == 20) {
        return 9.0;
      }
    }

    return 0.0;
  }

  loadBaseRateAndDistanceFactor() async {
    try {
      String url = mApiController().distanceFactor;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {"id": businessID};
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));

      var body = jsonDecode(response.body);
      BybriskDesign()
          .showInSnackBar(body['base_rate'].toString(), _scaffoldKey);
      setState(() {
        baseRate = body['base_rate'];
        distanceFactor = body['distance_factor'];
      });

      setState(() {
        isAdding = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection", _scaffoldKey);
    }
  }
}
