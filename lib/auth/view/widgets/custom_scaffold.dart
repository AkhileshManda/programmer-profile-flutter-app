import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget customScaffold({GlobalKey<ScaffoldState>? scaffoldKey, required Widget body, AppBar? appBar}){
    return Scaffold(
      appBar: appBar ?? AppBar(backgroundColor: Colors.transparent,),
      backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
      body: Stack(
        children: [
           LottieBuilder.asset("assets/animations/bg-1.json"),
           body
        ],
      ),
  );
}