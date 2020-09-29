import 'package:bybrisk/style/transaction.dart';
import 'package:bybrisk/views/Home.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Container(
          width: 150.0,
          height: 150.0,
          child: FlareActor(
            "assets/animation/checkbox.flr",
            fit: BoxFit.cover,
            alignment: Alignment.center,
            animation: "play",
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                FadeRouteBuilder(page: Home()));
          }, label: Text("Go to Dashboard")),
    );
  }
}
