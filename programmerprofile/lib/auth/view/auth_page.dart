import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = "authScreen";
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO : add Image
            const Text("Title"),
            const Text("Subtitle"),
            ElevatedButton(
              onPressed: (){
                //TODO : Implement Authentication
              }, 
              child: const Text("Sign in with github")
            )
          ],
        ),
      ),
    );
  }
}