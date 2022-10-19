import 'package:flutter/material.dart';
import 'package:programmerprofile/temp_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/controller/auth.dart';
import 'auth/view/login_page.dart';
import 'auth/view/sign_up_page.dart';
import 'auth/view/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName = "/splashScreen";
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    print(_seen);
    if (_seen) {
      _handleStartScreen();
      Navigator.pushNamed(context, LoginScreen.routeName);

    } else {
      await prefs.setBool('seen', true);
      Navigator.pushNamed(context, OnboardingPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 4, 24, 40),
      ),
      
    );
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  Future<void> _handleStartScreen() async {

    final prefs = await SharedPreferences.getInstance();
    print(prefs.toString());
    print(prefs.getString('token'));
    if (prefs.getString('token')==null) {
      Navigator.popAndPushNamed(context, LoginScreen.routeName);
    } else {
      Navigator.popAndPushNamed(context, Home.routeName);
    }
  }
}