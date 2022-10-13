import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    if (_seen) {
      //_handleStartScreen();
      Navigator.pushNamed(context, LoginScreen.routeName);

    } else {
      await prefs.setBool('seen', true);
      Navigator.pushNamed(context, OnboardingPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        //TODO : ADD APP LOGO INSTEAD OF CircularProgressIndicator
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  Future<void> _handleStartScreen() async {

    // //Auth _auth = Auth();

    // if (await _auth.isLoggedIn()) {
    //   //Navigator.popAndPushNamed(context, ChatScreen.id);
    // } else {
    //   //Navigator.popAndPushNamed(context, WelcomeScreen.id);
    // }
  }
}