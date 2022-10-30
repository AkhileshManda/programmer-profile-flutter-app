import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/home/controller/apis.dart';
import 'package:programmerprofile/home/view/widgets/codeforces_graphs.dart';
import 'package:programmerprofile/home/view/widgets/drawer.dart';
import 'package:programmerprofile/home/view/edit_bio_page.dart';
import '../../auth/model/user.dart';
import 'widgets/github_charts.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = 'home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final ScrollController controller = ScrollController();
  bool githubOn = true;
  bool codeforcesOn = false;
  // List of values: [User object, Map<Date,Contribution>, CFGraphData, GithubData]
  Future<List<dynamic>>? _getData;
  APIs apis = APIs();

  @override
  void initState() {
    super.initState();
    _getData = Future.wait([
      apis.getUser(),
      apis.getHeatMapData(),
      apis.getCFGraphData(),
      apis.getGithubData(),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerTemplate(
        body: Scaffold(
            backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
            body: SafeArea(
                child: Stack(children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                    //shrinkWrap: true,
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: _getData,
                        builder: (ctx, AsyncSnapshot<List<dynamic>> snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snap.hasData) {
                            //print(snap.data.toString());
                            User user = snap.data![0];
                            return Column(
                              children: [
                                snap.data![0] != null
                                    ? (Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      z.toggle!();
                                                    },
                                                    icon: const Icon(Icons.menu,
                                                        color: Colors.white)),
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor:
                                                      const Color.fromRGBO(
                                                          0, 10, 56, 1),
                                                  child: user.profilePicture ==
                                                          null
                                                      ? const Icon(Icons.person)
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(user
                                                                      .profilePicture!)),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          200))),
                                                        ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(user.username!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      )),
                                                ),
                                                const Icon(
                                                    Icons
                                                        .notification_add_sharp,
                                                    color: Colors.white)
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    //color: Color.fromARGB(255, 125, 10, 48),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                //height: 200,
                                                child: Column(
                                                  children: [
                                                    Markdown(
                                                      styleSheet:
                                                          MarkdownStyleSheet(
                                                        p: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                      shrinkWrap: true,
                                                      controller: controller,
                                                      selectable: true,
                                                      data: user.description ==
                                                              null
                                                          ? "Add profile description in markdown"
                                                          : user.description!,
                                                      extensionSet:
                                                          md.ExtensionSet(
                                                        md
                                                            .ExtensionSet
                                                            .gitHubFlavored
                                                            .blockSyntaxes,
                                                        [
                                                          md.EmojiSyntax(),
                                                          ...md
                                                              .ExtensionSet
                                                              .gitHubFlavored
                                                              .inlineSyntaxes
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (ctx) =>
                                                                              const EditorScreen()));
                                                            },
                                                            icon: const Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white),
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
                                      ))
                                    : (const Text("Failed Lmao")),
                                snap.data![1] != null
                                    ? (HeatMap(
                                        defaultColor: Colors.white,
                                        datasets: snap.data![1],
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
                                                  content: Text(
                                                      "${snap.data![1][value].toString()}+ contributions")));
                                        },
                                        textColor: Colors.white,
                                        //margin: EdgeInsets.all(8.0),
                                        showColorTip: false,
                                      ))
                                    : (const Text("Could'nt load map")),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(color: Colors.black),

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 120,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: GestureDetector(
                                              onTap: () {
                                                //print("github pressed");
                                                setState(() {
                                                  codeforcesOn = true;
                                                  githubOn = false;
                                                });
                                              },
                                              child: const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Text("Codeforces"),
                                                ),
                                              )),
                                        ),
                                        Container(
                                          width: 120,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: GestureDetector(
                                              onTap: () {
                                                //print("github pressed");
                                                setState(() {
                                                  codeforcesOn = false;
                                                  githubOn = true;
                                                });
                                              },
                                              child: const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Text("Github"),
                                                ),
                                              )),
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                snap.data![2] != null && codeforcesOn
                                    ? (CodeforcesGraphs(
                                        barGraphData: snap.data![2]["bar"],
                                        donutGraphData: snap.data![2]["donut"],
                                        ratingGraphData: snap.data![2]
                                            ["rating"],
                                      ))
                                    : (snap.data![3] == null
                                        ? const Text("Couldn't Load Graphs")
                                        : const SizedBox()),
                                snap.data![3] != null && githubOn
                                    ? (GitHubCharts(
                                        data: snap.data![3]["details"],
                                        languagedata: snap.data![3]
                                            ["languageData"],
                                      ))
                                    : (snap.data![3] == null
                                        ? const Text("Couldn't Load Graphs")
                                        : const SizedBox())
                              ],
                            );
                          }
                          return const Center(
                            child: Text("No data found"),
                          );
                        },
                      ),
                    ]),
              ),
            ]))));
  }
}
