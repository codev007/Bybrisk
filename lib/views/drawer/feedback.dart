import 'dart:convert';
import 'dart:io';
import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/style/design.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:bybrisk/database/apiController.dart';
import 'package:bybrisk/style/dimen.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:bybrisk/style/string.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _feedback = "";
  String businessID;
  bool isLoading = false;
  _getData() async {
    String tempID = await SharedDatabase().getBusinessID();
    setState(() {
      businessID = tempID;
    });
  }

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

      ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : SingleChildScrollView(
            child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "How can We\nImprove Bybrisk\nTogether",
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.primaryColor,
                            fontSize: BybriskDimen().exlarge),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
                      padding: EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      child: TextField(
                        minLines: 5,
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            _feedback = value;
                          });
                        },
                        decoration:
                            InputDecoration(hintText: "Share your thoughts here"),
                      ),
                    ),
                    _feedback.length > 0
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: RaisedButton(
                              color: CustomColor.BybriskColor.primaryColor,
                              child: Text("SEND NOW",style: TextStyle(color: CustomColor.BybriskColor.white),),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                this._sendFeedback();
                              },
                            ))
                        : Container(),
                    Container(
                      height: 60.0,
                    )
                  ],
                ),
              ),
          ),
    );
  }

  void _sendFeedback() async {
    try {
      String url = mApiController().feedback;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {
        "feedback": _feedback,
        "business_id": businessID
      };
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        BybriskDesign().showInSnackBar(
            "Thank you for your valuable feedback", _scaffoldKey);
      } else {
        BybriskDesign()
            .showInSnackBar("May be missing something !", _scaffoldKey);
      }
      setState(() {
        isLoading = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar("Internet connection lost", _scaffoldKey);
    }
  }
}
