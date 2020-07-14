import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    // only applied when this field is not in focus
    borderSide: BorderSide(color: Colors.black, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    // applied when field is in focus)
    borderSide: BorderSide(color: Colors.pink, width: 2),
  ),
);

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.brown,
          size: 50.0,
        ),
      ),
    );
  }
}
