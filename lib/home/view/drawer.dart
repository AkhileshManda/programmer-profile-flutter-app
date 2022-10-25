import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/contests/view/contests_page.dart';
import 'package:programmerprofile/home/view/profile_page.dart';
import 'package:programmerprofile/home/view/temp_home.dart';

final ZoomDrawerController z = ZoomDrawerController();

class DrawerTemplate extends StatefulWidget {
  final Widget body;
  const DrawerTemplate({Key? key, required this.body}) : super(key: key);

  @override
  DrawerTemplateState createState() => DrawerTemplateState();
}

class DrawerTemplateState extends State<DrawerTemplate> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: z,
      borderRadius: 24,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      angle: 0.0,
      menuBackgroundColor: const Color.fromRGBO(0, 10, 56, 1),
      mainScreen: widget.body,
      menuScreen: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: Stack(children: [
          Center(
            child: LottieBuilder.asset(
              "assets/animations/bg-1.json",
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton.icon(
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, Home.routeName);
                      },
                      icon: const FaIcon(FontAwesomeIcons.houseChimney, color: Colors.white),
                      label: const Text("Home")),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, ContestsScreen.routeName);
                      },
                      icon: const FaIcon(FontAwesomeIcons.trophy, color: Colors.white),
                      label: const Text("Contests And Events")),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                      },
                      icon: const FaIcon(FontAwesomeIcons.user, color: Colors.white),
                      label: const Text("Profile")),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
