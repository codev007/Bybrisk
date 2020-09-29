import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:bybrisk/style/string.dart';
import 'package:bybrisk/style/transaction.dart';
import 'package:bybrisk/views/chooseCategory.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String name, email, business_name, mobile;
  TextEditingController _address = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();
  double lat;
  double lang;
  Uuid uuid = Uuid();
  String apiKey = "AIzaSyCl2hdW1gv9Wr_YoJP09U7mz5bCaby2zuw";
  PickResult _pickedLocation;
  getMobile() async {
    String temp = await SharedDatabase().getMobile();
    setState(() {
      mobile = temp;
    });
    print(mobile);
  }

  @override
  void initState() {
    this.getMobile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                margin: EdgeInsets.only(top: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        BybrickString().signupQuote,
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.primaryColor,
                            fontSize: BybriskDimen().large),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Complete your \nProfile",
                        style: TextStyle(
                            fontSize: BybriskDimen().exlarge,
                            color: Colors.black45),
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                      child: Text(
                        "Verified mobile number",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: Bybriskfont().small,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      child: Text(
                        mobile,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: Bybriskfont().large,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "your name".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        obscureText: false,
                        onChanged: (value) {
                          setState(() {
                            this.name = value.toString();
                          });
                        },
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Your name',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(
                        "Email address".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        obscureText: false,
                        onChanged: (value) {
                          setState(() {
                            this.email = value.toString();
                          });
                        },
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Your Email',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(
                        "Business name".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        onChanged: (value) {
                          setState(() {
                            this.business_name = value.toString();
                          });
                        },
                        //  controller: password,
                        obscureText: false,
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Business Name',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(
                        "Address of Business".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        onTap: () async {
                          showPlacePicker();
                          if (_pickedLocation != null) {
                            Coordinates cord = Coordinates(
                                _pickedLocation.geometry.location.lat,
                                _pickedLocation.geometry.location.lng);
                            var addresses = await Geocoder.local
                                .findAddressesFromCoordinates(cord);
                            var first = addresses.first;
                            setState(() {
                              _address.text = _pickedLocation.adrAddress;
                              _pincode.text = first.postalCode;
                              lat = _pickedLocation.geometry.location.lat;
                              lang =  _pickedLocation.geometry.location.lng;
                            });
                          }
                        },
                        autofocus: false,
                        controller: _address,
                        //  controller: password,
                        obscureText: false,
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Address of Business',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(
                        "Location pincode".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        controller: _pincode,
                        obscureText: false,
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Pincode',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BybriskDesign().hollowButtonDesign(),
                      margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
                      child: InkWell(
                        splashColor: CustomColor.BybriskColor.white,
                        onTap: () {
                          if (name.length > 0 &&
                              email.length > 0 &&
                              business_name.length > 0 &&
                              _address.text.length > 0 &&
                              _pincode.text.length > 0 &&
                              mobile.length > 0) {
                            setState(() {
                              isLoading = true;
                            });
                            mSignup(
                                uuid.v1().toString(),
                                name,
                                email,
                                business_name,
                                _address.text,
                                _pincode.text,
                                mobile);
                          } else {
                            BybriskDesign().showInSnackBar(
                                "Feilds are missing !", _scaffoldKey);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 15.0, left: 15.0),
                          child: Text(
                            "Submit Now",
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
    );
  }

  void mSignup(
      String id, name, email, bussiness_name, address, pincode, mobile) async {
    try {
      String url = mApiController().signup;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {
        "id": id,
        "name": name,
        "email": email,
        "business_name": bussiness_name,
        "address": address,
        "pincode": pincode,
        "mobile": mobile,
        "lat": lat,
        "lang": lang
      };
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setDone(true);
        SharedDatabase().setProfileData(id, name, email, bussiness_name,
            address, mobile, pincode, false, lat, lang);
        Navigator.of(context)
            .pushReplacement(FadeRouteBuilder(page: BusinessCategory()));
      } else {
        BybriskDesign()
            .showInSnackBar("Problem occurs ! Please try again", _scaffoldKey);
      }
      setState(() {
        isLoading = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("No internet connection", _scaffoldKey);
      mSignup(id, name, email, bussiness_name, address, pincode, mobile);
    }
  }

  void showPlacePicker() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: apiKey, // Put YOUR OWN KEY here.
          onPlacePicked: (result) {
            
            setState(() {
              _pickedLocation=result;
            });
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(-33.8567844, 151.213108),
          useCurrentLocation: true,
        ),
      ),
    );
  }
}
