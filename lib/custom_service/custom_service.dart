import 'package:flutter/material.dart';

class CustomService {
  CustomService._();

  static void showMessage(final _scaffoldKey, String message,
      {Color backgroundColor = const Color(0xFFff8b54)}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}