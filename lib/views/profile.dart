import 'package:bybrisk/database/BybriskSharedPreferences.dart';
import 'package:bybrisk/style/design.dart';
import 'package:bybrisk/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:flutter/rendering.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String businessName;
  String businessAddress;
  String businessMobile;
  String businessPincode;
  String businessEmail;
  _getProfileData() async {
    String tempName = await SharedDatabase().getBusinessname();
    String tempMobile = await SharedDatabase().getMobile();
    String tempPincode = await SharedDatabase().getPincode();
    String tempEmail = await SharedDatabase().getEmail();
    String tempAddress = await SharedDatabase().getEmail();
    setState(() {
      businessName = tempName;
      businessEmail = tempEmail;
      businessPincode = tempPincode;
      businessAddress = tempAddress;
      businessMobile = tempMobile;
    });
  }

  @override
  void initState() {
    _getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              "Business Name",
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              businessName,
              style: TextStyle(
                  fontFamily: Bybriskfont().large,
                  color: CustomColor.BybriskColor.textPrimary,
                  fontSize: 20.0),
            ),
          ),
          BybriskDesign().bigSpacer(),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Text(
              "Business Address",
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              businessAddress,
              style: TextStyle(
                  fontFamily: Bybriskfont().large,
                  color: CustomColor.BybriskColor.textPrimary,
                  fontSize: 20.0),
            ),
          ),
          BybriskDesign().bigSpacer(),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Text(
              "Business Pincode",
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              businessPincode,
              style: TextStyle(
                  fontFamily: Bybriskfont().large,
                  color: CustomColor.BybriskColor.textPrimary,
                  fontSize: 20.0),
            ),
          ),
          BybriskDesign().bigSpacer(),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Text(
              "Business Mobile",
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              businessMobile,
              style: TextStyle(
                  fontFamily: Bybriskfont().large,
                  color: CustomColor.BybriskColor.textPrimary,
                  fontSize: 20.0),
            ),
          ),
          BybriskDesign().bigSpacer(),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Text(
              "Business Email",
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              businessEmail,
              style: TextStyle(
                  fontFamily: Bybriskfont().large,
                  color: CustomColor.BybriskColor.textPrimary,
                  fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }
}
