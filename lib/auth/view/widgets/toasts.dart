import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Toasts{
  static void successToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: Colors.green,
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.green,
      fontSize: 15,
      gravity: ToastGravity.BOTTOM
    );
  }
  static void failedToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: Colors.red,
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      fontSize: 15,
      gravity: ToastGravity.BOTTOM
    );
  }

}