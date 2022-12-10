import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:programmerprofile/userSearch/controller/apis.dart';
import '../../auth/model/user.dart';
import '../../home/view/widgets/codeforces_graphs.dart';
import '../../home/view/widgets/drawer.dart';
import '../../home/view/widgets/github_charts.dart';
import '../../home/view/widgets/lc_tags_chart.dart';

class NewUserScreen extends StatefulWidget {
  final String id;
  final String name;
  //final String email;
  final String? profilepic;
  final String? description;
  final bool isFollowing;
  const NewUserScreen({
    super.key,
    required this.id,
    required this.name,
    //required this.email,
    required this.profilepic,
    required this.description,
    required this.isFollowing,
  });
  static const routeName = 'new-user-page';
  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final ScrollController controller = ScrollController();
  bool githubOn = true;
  bool codeforcesOn = false;
  bool leetcodeOn = false;
  late User? user;
  // List of values: [User object, Map<Date,Contribution>, CFGraphData, GithubData]
  Future<List<dynamic>>? _getData;
  OtherUserAPIs apis = OtherUserAPIs();
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    _getData = Future.wait([
      apis.getOtherHeatMapData(widget.id),
      apis.getOtherCFGraphData(widget.id),
      apis.getOtherGithubData(widget.id),
      apis.getOtherLeetCodeData(widget.id)
    ]);
    isFollowing = widget.isFollowing;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget navTile(
      {required String title, required Function onPressed, required}) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 120,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 220, 10, 94),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
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
                                      const Color.fromRGBO(0, 10, 56, 1),
                                  child: widget.profilepic == null
                                      ? const Icon(Icons.person)
                                      : Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      widget.profilepic!)),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(200))),
                                        ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(widget.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      )),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      bool x = await apis.toggleFollow(
                                          isFollowing ? "REMOVE" : "ADD",
                                          widget.id);
                                      if (x) {
                                        setState(() {
                                          isFollowing = !isFollowing;
                                        });
                                      }
                                    },
                                    child: isFollowing
                                        ? const Text("Following")
                                        : const Text("Follow")),
                              ],
                            ),
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
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      shrinkWrap: true,
                                      controller: controller,
                                      selectable: true,
                                      data: widget.description == null
                                          ? "No description"
                                          : widget.description!,
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
                                  ],
                                ),
                              ),
                            ),
                            FutureBuilder<List<dynamic>>(
                              future: _getData,
                              builder:
                                  (ctx, AsyncSnapshot<List<dynamic>> snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snap.hasData) {
                                  //print(snap.data.toString());
                                  // print(snap.data![0].runtimeType);
                                  // print(snap.data![1].runtimeType);
                                  // print(snap.data![2].runtimeType);
                                  return Column(
                                    children: [
                                      snap.data![0] != null
                                          ? (HeatMap(
                                              defaultColor: Colors.white,
                                              datasets: snap.data![0],
                                              //datasets: data,
                                              colorMode: ColorMode.opacity,
                                              showText: false,
                                              scrollable: true,
                                              colorsets: const {
                                                5: Colors.pink,
                                                3: Color.fromARGB(
                                                    255, 199, 4, 137),
                                                1: Color.fromARGB(
                                                    255, 121, 0, 97),
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
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Container(
                                          height: 60,
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent),
                                          child: ListView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              navTile(
                                                  title: "Codeforces",
                                                  onPressed: () {
                                                    setState(() {
                                                      codeforcesOn = true;
                                                      githubOn = false;
                                                      leetcodeOn = false;
                                                    });
                                                  }),
                                              navTile(
                                                  title: "GitHub",
                                                  onPressed: () {
                                                    setState(() {
                                                      githubOn = true;
                                                      codeforcesOn = false;
                                                      leetcodeOn = false;
                                                    });
                                                  }),
                                              navTile(
                                                  title: "Leetcode",
                                                  onPressed: () {
                                                    setState(() {
                                                      leetcodeOn = true;
                                                    githubOn = false;
                                                    codeforcesOn = false;
                                                    });
                                                  })
                                            ],
                                          ),
                                        ),
                                      ),
                                      snap.data![1] != null && codeforcesOn
                                          ? (CodeforcesGraphs(
                                              barGraphData: snap.data![1]
                                                  ["bar"],
                                              donutGraphData: snap.data![1]
                                                  ["donut"],
                                              ratingGraphData: snap.data![1]
                                                  ["rating"],
                                            ))
                                          : (snap.data![1] == null
                                              ? const Text(
                                                  "Couldn't Load Graphs")
                                              : const SizedBox()),
                                      snap.data![2] != null && githubOn
                                          ? (GitHubCharts(
                                              data: snap.data![2]["details"],
                                              languagedata: snap.data![2]
                                                  ["languageData"],
                                            ))
                                          : (snap.data![2] == null
                                              ? const Text(
                                                  "Couldn't Load Graphs")
                                              : const SizedBox()),
                                      snap.data![3] != null && leetcodeOn
                                          ? (LCTagsGraph(
                                              tags: snap.data![3]["tagDetails"],
                                              contests: snap.data![3]
                                                  ["contestHistory"],
                                              languagedata: snap.data![3]
                                                  ["languageStats"],
                                            ))
                                          : (snap.data![3] == null
                                              ? const Text(
                                                  "Couldn't Load Leetcode Graphs")
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
                      ]))
            ]))));
  }
}
