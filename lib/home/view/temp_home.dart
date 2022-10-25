import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/controller/auth.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/home/controller/queries.dart';
import 'package:programmerprofile/home/view/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/view/login_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = 'home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<DateTime, int>? data = {};

  Future<Map<DateTime, int>?> getHeatMapData() async {
    // setState(() {
    //   isLoading = false;
    // });

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.getContributions()),
    ));

    if (result.hasException) {
      //print(result.exception);
      // setState(() {
      //   isLoading = false;
      // });
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));
      //_passwordCon.clear();

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print(result.data);
      //print(result.data!["contributionGraph"]["contributions"]);
      for (var activity in result.data!["contributionGraph"]["contributions"]) {
        int contributionSum = activity["githubContributions"] +
            activity["codeforcesContributions"] +
            activity["leetcodeContributions"];
        //print(activity["date"]+" "+contributionSum.toString() );
        DateTime date = DateFormat("yyyy-MM-dd").parse(activity["date"]);
        data!.putIfAbsent(date, () => contributionSum);
      }
      //print(data.toString());
      return data;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    getHeatMapData();
    return DrawerTemplate(
      body: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: SafeArea(
          child: Stack(
            children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              z.toggle!();
                            },
                          ),
                          const Text("Home", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ))
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: getHeatMapData(),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            bool flag = false;
                            for (var key in data!.keys) {
                              if (data![key] != 0) {
                                flag = true;
                              }
                            }
                            return flag
                                ? HeatMap(
                                    defaultColor: Colors.white,
                                    datasets: data,
                                    //datasets: data,
                                    colorMode: ColorMode.opacity,
                                    showText: false,
                                    scrollable: true,
                                    colorsets: const {
                                      5: Colors.pink,
                                      3: Color.fromARGB(255, 199, 4, 137),
                                      1: Color.fromARGB(255, 121, 0, 97),
                                     
                                    },
                                    onClick: (value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("${data![value].toString()}+ contributions")));
                                    },
                                    textColor: Colors.white,
                                    //margin: EdgeInsets.all(8.0),
                                    showColorTip: false,
                                  )
                                : Wrap(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "No Contributions, make sure your accounts are added",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                          }
                          return const CircularProgressIndicator();
                        }),
                    //const Text("HOME"),
                    ElevatedButton(
                        onPressed: () async {
                          Auth().logout();
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: const Text("Log out"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
