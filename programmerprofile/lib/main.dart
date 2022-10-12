import 'package:flutter/material.dart';
import 'package:programmerprofile/auth/view/auth_page.dart';
import 'package:programmerprofile/splash.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'auth/view/onboarding_page.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnBoarding(),//SplashScreen(),
      routes: {
       // '/': (ctx) => SplashScreen(),
        OnBoarding.routeName : (ctx) => OnBoarding(),
        AuthScreen.routeName : (ctx) => AuthScreen(),
      },
    );
  }
}
