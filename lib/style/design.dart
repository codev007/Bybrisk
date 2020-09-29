import 'package:bybrisk/style/colors.dart' as CustomColor;
import 'package:bybrisk/style/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BybriskDesign {
  hollowButtonDesign() {
    return BoxDecoration(
        color: CustomColor.BybriskColor.primaryColor,
        border: Border.all(width: 1, color: CustomColor.BybriskColor.white),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ));
  }

  dropdownDesign() {
    return BoxDecoration(
        color: Colors.black12,
        //     border: Border.all(width: 1, color: CustomColor.BybriskColor.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ));
  }

  hollowsubmitDesign() {
    return BoxDecoration(
        //     color: CustomColor.BybriskColor.white,
        border: Border.all(
            width: 0.25, color: CustomColor.BybriskColor.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ));
  }

  spacer() {
    return Container(
      height: 1.0,
      color: CustomColor.BybriskColor.textSecondary,
    );
  }
  bigSpacer() {
    return Container(
      height: 6.0,
      color: Colors.black12,
    );
  }

  void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(value),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

  drawerListText() {
    return TextStyle(fontFamily: Bybriskfont().large);
  }
}
