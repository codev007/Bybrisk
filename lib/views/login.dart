import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:bybrisk/style/string.dart';
import 'package:bybrisk/style/transaction.dart';
import 'package:bybrisk/views/Home.dart';
import 'package:bybrisk/views/chooseCategory.dart';
import 'package:bybrisk/views/payment.dart';
import 'package:bybrisk/views/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _mobile = new TextEditingController();
  bool showVerified = false;
  bool isVerifing = false;
  bool otpVerifing = false;
  String statusMessage = "";
  String _smsCode;
  String dialogSms = "Please check your phone for the verification code.";
  String verifyStatus = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  String mMobileNumber;
  getMobile() async {
    String temp = await SharedDatabase().getMobile();
    setState(() {
      mMobileNumber = temp;
    });
    print("Mobile Number =======================" + mMobileNumber);
    if (mMobileNumber.length != null) {
      Navigator.of(context).pushReplacement(FadeRouteBuilder(page: SignUp()));
    }
  }

  @override
  void initState() {
    getMobile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  BybrickString().loginQuote,
                  style: TextStyle(
                      fontFamily: Bybriskfont().large,
                      color: CustomColor.BybriskColor.primaryColor,
                      fontSize: BybriskDimen().large),
                ),
              ),
              Container(
                height: 50.0,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5.0),
                alignment: Alignment.topLeft,
                child: Text(
                  statusMessage.toUpperCase(),
                  style: TextStyle(
                      fontSize: BybriskDimen().exsmall, color: Colors.red),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5.0),
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter your mobile number".toUpperCase(),
                  style: TextStyle(fontSize: BybriskDimen().exsmall),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        child: TextFormField(
                          enabled: !isVerifing,
                          //  maxLength: 10,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          controller: _mobile,
                          obscureText: false,
                          onChanged: (value) {
                            if (value.length == 10) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                isVerifing = true;
                              });
                              _verifyPhoneNumber();
                            } else {
                              setState(() {
                                isVerifing = false;
                              });
                            }
                          },
                          //    validator: Validate().validatePassword,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: '10 digit mobile number',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    isVerifing
                        ? Container(
                            margin: EdgeInsets.only(left: 10.0),
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ))
                        : Container()
                  ],
                ),
              ),
              Container(
                height: 50.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  _otpSheet() {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (contex) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 18.0, left: 10.0, right: 10.0),
                          child: Text(
                            "OTP Verification",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: Bybriskfont().large,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 5.0, left: 10.0, right: 10.0),
                          child: Text(
                            "Sent to",
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
                            "+91" + _mobile.text.toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: Bybriskfont().large,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0))),
                                  child: TextFormField(
                                    enabled: !otpVerifing,
                                    //  maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    //    controller: _mobile,
                                    obscureText: false,
                                    onChanged: (value) {
                                      if (value.length == 6) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        setStates(() {
                                          _smsCode = value;
                                          otpVerifing = true;
                                        });
                                        FirebaseAuth.instance
                                            .currentUser()
                                            .then((user) {
                                          if (user != null) {
                                            mLonIn("+91" +
                                                _mobile.text.toString());
                                          } else {
                                            _signInWithPhoneNumber();
                                          }
                                        });
                                      } else {
                                        setStates(() {
                                          otpVerifing = false;
                                        });
                                      }
                                    },
                                    //    validator: Validate().validatePassword,
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: '6 digit OTP',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 5.0, 20.0, 5.0),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              otpVerifing
                                  ? Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      width: 30.0,
                                      height: 30.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                      ))
                                  : Container()
                            ],
                          ),
                        ),
                        Container(
                          height: 20.0,
                        )
                      ],
                    ),
                  ));
            },
          );
        });
  }

  void mLonIn(String mobile) async {
    try {
      String url = mApiController().logIn;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {"mobile": mobile};
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        SharedDatabase().setProfileData(
            body['id'],
            body['name'],
            body['email'],
            body['business_name'],
            body['address'],
            body['mobile'],
            body['pincode'],
            body['category'],
            body['lat'],
            body['lang']);
        SharedDatabase().setLogin(true);
        SharedDatabase().setCategory(body['category']);
        if (!body['category']) {
          Navigator.of(context)
              .pushReplacement(FadeRouteBuilder(page: BusinessCategory()));
        } else {
          SharedDatabase().setDone(true);
          Navigator.of(context).pushReplacement(FadeRouteBuilder(page: Home()));
        }
      } else {
        SharedDatabase().setCategory(false);
        SharedDatabase().setDone(false);
        SharedDatabase().setLogin(true);
        SharedDatabase().setMobile(mobile);
        Navigator.of(context).pushReplacement(FadeRouteBuilder(page: SignUp()));
      }
      setState(() {
        isVerifing = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("Internet connection lost", _scaffoldKey);
      setState(() {
        isVerifing = false;
      });
    }
  }

  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      if (user.uid == currentUser.uid) {
        assert(user.uid == currentUser.uid);
        setState(() {
          if (user != null) {
            mLonIn('+91' + _mobile.text.toString());
          } else {
            setState(() {
              this.statusMessage = "Invailed OTP ! Please enter correct OTP";
              isVerifing = false;
            });
          }
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        this.statusMessage = "Invailed OTP ! Please enter correct OTP";
        isVerifing = false;
      });
    }
  }

  //  code of  verify phone number
  void _verifyPhoneNumber() async {
    setState(() {});
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        //     _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        isVerifing = false;
        this.statusMessage =
            "Invailed Mobile ! Please enter correct phone number";
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        isVerifing = false;
        _otpSheet();
        //   _message = "Please check your phone for the verification code.";
      });
      /*    widget._scaffold.showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));
      */
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+91' + _mobile.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
