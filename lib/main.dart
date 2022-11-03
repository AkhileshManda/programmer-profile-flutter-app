import 'package:flutter/material.dart';
import 'package:programmerprofile/auth/view/forgot_password_page.dart';
import 'package:programmerprofile/auth/view/sign_up_page.dart';
import 'package:programmerprofile/home/view/profile_page.dart';
//import 'package:programmerprofile/home/view/temp_home2.dart';
import 'package:programmerprofile/splash.dart';
import 'package:programmerprofile/home/view/temp_home.dart';
import 'package:programmerprofile/userSearch/view/search_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'auth/view/login_page.dart';
import 'auth/view/onboarding_page.dart';
import 'contests/view/contest_page.dart';


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
      title: 'Programmer Profile',
      home:const SplashScreen(),//OnboardingPage(),//SplashScreen(),
      theme: ThemeData(
        // textTheme: const TextTheme(
        //   titleSmall: 
        // )
      ),
      routes: {
       // '/': (ctx) => SplashScreen(),
        OnboardingPage.routeName : (ctx) => OnboardingPage(),
        SignUpScreen.routeName : (ctx) => const SignUpScreen(),
        LoginScreen.routeName : (ctx) => const LoginScreen(),
        ForgotPasswordScreen.routeName : (ctx) => const ForgotPasswordScreen(),
        Home.routeName : (ctx) => const Home(),
        //MyHomePage.routeName : (ctx) => MyHomePage(),
        ProfileScreen.routeName : (ctx) => const ProfileScreen(),
        SearchUserScreen.routeName : (ctx) => const SearchUserScreen(),
        ContestPage.routeName : (ctx) => const ContestPage(),
      },
    );
  }
}
