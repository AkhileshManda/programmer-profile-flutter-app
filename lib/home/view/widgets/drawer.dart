import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/controller/auth.dart';
import 'package:programmerprofile/auth/view/login_page.dart';
import 'package:programmerprofile/contests/view/contest_page.dart';
import 'package:programmerprofile/home/view/profile_page.dart';
// import 'package:programmerprofile/home/view/temp_home.dart';
import 'package:programmerprofile/userSearch/view/search_page.dart';



class DrawerTemplate extends StatefulWidget {
  final Widget body;
  final ZoomDrawerController z;
  const DrawerTemplate({Key? key, required this.body, required this.z}) : super(key: key);
  @override
  DrawerTemplateState createState() => DrawerTemplateState();
  
}

class DrawerTemplateState extends State<DrawerTemplate> {
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: widget.z,
      borderRadius: 24,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      angle: 0.0,
      menuBackgroundColor: const Color.fromRGBO(0, 10, 56, 1),
      mainScreen: widget.body,
      menuScreen: Stack(children: [
        Center(
          child: LottieBuilder.asset(
            "assets/animations/bg-1.json",
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                    onPressed: (){
                      // print("CLOSE");
                      widget.z.close;
                    },
                    icon: const FaIcon(FontAwesomeIcons.houseUser,
                        color: Colors.white),
                    label: const Text("Home")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, ContestPage.routeName);
                    },
                    icon: const FaIcon(FontAwesomeIcons.trophy,
                        color: Colors.white),
                    label: const Text("Contests And Events")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    icon: const FaIcon(FontAwesomeIcons.user,
                        color: Colors.white),
                    label: const Text("Profile")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, SearchUserScreen.routeName);
                    },
                    icon: const FaIcon(FontAwesomeIcons.search,
                        color: Colors.white),
                    label: const Text("Search Users")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 80,
                  child: ElevatedButton(
                      onPressed: () {
                        Auth().logout();
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: const Text("Logout")),
                ),
              )
              
            ],
          ),
        ),
      ]),
    );
  }
}
