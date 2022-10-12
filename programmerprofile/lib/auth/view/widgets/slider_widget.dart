import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  String? image;
  SliderWidget({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // image given in slider
          Image(image: AssetImage(image!)),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
