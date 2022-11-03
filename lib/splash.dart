import 'package:flutter/material.dart';
import 'package:programmerprofile/home/view/temp_home.dart';
//import 'package:programmerprofile/home/view/temp_home2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/view/login_page.dart';
import 'auth/view/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName = "/splashScreen";
  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    //print(_seen);
    
    if (seen) {
      _handleStartScreen();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);

    } else {
      await prefs.setBool('seen', true);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, OnboardingPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 4, 24, 40),
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
    //print(prefs.toString());
   // print(prefs.getString('token'));
    if (!mounted) return;
    if (prefs.getString('token')==null) {
      Navigator.popAndPushNamed(context, LoginScreen.routeName);
    } else {
      Navigator.popAndPushNamed(context, Home.routeName);
    }
  }
}