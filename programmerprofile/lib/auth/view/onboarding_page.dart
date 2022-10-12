import 'package:flutter/material.dart';
import 'package:programmerprofile/auth/view/auth_page.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);
  static const routeName = "Onboarding";
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  late PageController _controller;
  List<Widget> pages = [
    page1(), page2(), page3()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 88, 194),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return pages[index];
                }),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentIndex > 0
                      ? IconButton(
                          icon: Icon(
                            currentIndex == pages.length - 1
                                ? Icons.arrow_back_ios
                                : Icons.arrow_back_ios,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _controller.previousPage(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.bounceIn);
                          },
                        )
                      : Container(),
                  IconButton(
                    icon: Icon(
                      currentIndex == pages.length - 1
                          ? Icons.skip_next
                          : Icons.done,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print("PRESSED");
                      if (currentIndex == pages.length - 1) {
                        Navigator.pushReplacementNamed(context, AuthScreen.routeName);
                      }
                      _controller.nextPage(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.bounceIn);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //backgroundColor: Colors.white,
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green,
      ),
    );
  }
}

Widget page1() {
  return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 88, 194),
      body: Center(
        child: const Text("Page 1"),
      ));
}

Widget page2() {
  return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 88, 194),
      body: Center(
        child: const Text("Page 2"),
      ));
}
Widget page3() {
  return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 88, 194),
      body: Center(
        child: const Text("Page 3"),
      ));
}
