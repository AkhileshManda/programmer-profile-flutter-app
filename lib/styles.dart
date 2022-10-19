import 'package:flutter/material.dart';

class Styles {
  static InputDecoration textFieldStyle(String hintText) {
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white)),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText);
  }
}
