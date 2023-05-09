import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/view/sign_up_page.dart';
import 'package:programmerprofile/auth/view/widgets/on_boarding_card.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key? key}) : super(key: key);
  static const routeName = 'onboarding';
  final data = [
    OnBoardingData(
      title: "Connect",
      subtitle:
          "Connect your Codeforces, Leetcode, GitHub accounts all in one app",
      image: LottieBuilder.asset("assets/images/95348-coding-boy.json"),
      backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
      titleColor: Colors.pink,
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animations/bg-1.json"),
    ),
    OnBoardingData(
      title: "Code",
      subtitle:
          "Keep coding effectively while we help you keep track of your strength and weaknesses",
      image: LottieBuilder.asset("assets/images/98636-coding.json"),
      backgroundColor: Colors.white,
      titleColor: Colors.purple,
      subtitleColor: const Color.fromRGBO(0, 10, 56, 1),
      background: LottieBuilder.asset("assets/animations/bg-2.json"),
    ),
    OnBoardingData(
      title: "Collaborate",
      subtitle:
          "Collaborate with developers across the world and build innovative products",
      image: LottieBuilder.asset("assets/images/5482-connect.json"),
      backgroundColor: const Color.fromRGBO(71, 59, 117, 1),
      titleColor: Colors.yellow,
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animations/bg-3.json"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        duration: const Duration(seconds: 4),
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) {
          return OnBoardingCard(data: data[index]);
        },
        onFinish: () {
          Navigator.pushReplacementNamed(
            context,
            SignUpScreen.routeName,
          );
        },
      ),
    );
  }
}
