import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/controller/auth.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/home/controller/queries.dart';
import 'package:programmerprofile/home/view/drawer.dart';
import 'package:programmerprofile/home/view/edit_bio_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/model/user.dart';
import '../../auth/view/login_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = 'home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<DateTime, int>? data = {};
  final ScrollController controller = ScrollController();
  User? user;

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
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
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

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.getUserDashboard()),
    ));

    if (result.hasException) {
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
      user = User(
        username: result.data!["getUser"]["name"],
        description: result.data!["getUser"]["description"],
        email: result.data!["getUser"]["email"],
        profilePicture: result.data!["getUser"]["profilePicture"],
      );
      return user;
      //Navigator.pushReplacementNamed(context, Home.routeName);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //getHeatMapData();
    return DrawerTemplate(
      body: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: SafeArea(
          child: Stack(
            children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              ListView(
                shrinkWrap: true,
                children: [
                  FutureBuilder(
                      future: getUser(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          z.toggle!();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color.fromRGBO(
                                              0, 10, 56, 1),
                                          child: user!.profilePicture == null
                                              ? const Icon(Icons.person)
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(user!
                                                              .profilePicture!)),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  200))),
                                                ),
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(user!.username!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                    ),
                                    const Icon(Icons.notification_add_sharp,
                                        color: Colors.white)
                                  ],
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         SizedBox(
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width *
                                //               0.6,
                                //           child: Column(
                                //             children: [
                                //               Text(user!.username!,
                                //                   style: const TextStyle(
                                //                       color: Colors.white,
                                //                       fontSize: 20)),
                                //               Text(user!.email!,
                                //                   overflow:
                                //                       TextOverflow.ellipsis,
                                //                   style: const TextStyle(
                                //                       color: Colors.white,
                                //                       fontSize: 15))
                                //             ],
                                //           ),
                                //         ),
                                //         const CircleAvatar(
                                //             backgroundColor: Colors.white,
                                //             foregroundColor:
                                //                 Color.fromRGBO(0, 10, 56, 1),
                                //             radius: 50,
                                //             child:
                                //                 Icon(Icons.person, size: 50)),
                                //       ]),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        //color: Color.fromARGB(255, 125, 10, 48),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(color: Colors.grey)),
                                    //height: 200,
                                    child: Column(
                                      children: [
                                        Markdown(
                                          styleSheet: MarkdownStyleSheet(
                                            p: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          shrinkWrap: true,
                                          controller: controller,
                                          selectable: true,
                                          data: user!.description==null? "Add profile description in markdown": user!.description! ,
                                          extensionSet: md.ExtensionSet(
                                            md.ExtensionSet.gitHubFlavored
                                                .blockSyntaxes,
                                            [
                                              md.EmojiSyntax(),
                                              ...md.ExtensionSet.gitHubFlavored
                                                  .inlineSyntaxes
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              const EditorScreen()));
                                                },
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),

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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${data![value].toString()}+ contributions")));
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
                        return const Center(child: CircularProgressIndicator());
                      }),
                  //const Text("HOME"),

                  ElevatedButton(
                      onPressed: () async {
                        Auth().logout();
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: const Text("Log out")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
