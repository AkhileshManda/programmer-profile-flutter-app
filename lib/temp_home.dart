import 'package:flutter/material.dart';
import 'package:programmerprofile/auth/controller/auth.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'auth/view/login_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = 'home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("HOME"),
          ElevatedButton(
            onPressed: ()async{
              //print("Logout");
              Auth().logout();
              //final prefs = await SharedPreferences.getInstance();
              //print(prefs.getString('token'));
              Navigator.pushReplacementNamed(context, LoginScreen.routeName );
            }, 
            child: const Text("Log out")
          )
        ],
      ),),
    );
  }
}