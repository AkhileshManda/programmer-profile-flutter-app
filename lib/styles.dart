import 'package:flutter/material.dart';

class Styles {
  static const githubColor = Color.fromARGB(255, 40, 136, 171);
  static const  expansionColor = Color.fromARGB(255, 255, 4, 0);
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
