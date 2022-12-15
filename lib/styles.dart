import 'package:flutter/material.dart';

class Styles {
  static const githubColor = Color.fromARGB(255, 40, 136, 171);
  static final expansionColor = Colors.pink[400];
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
