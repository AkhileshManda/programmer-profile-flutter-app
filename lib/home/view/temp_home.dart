import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_zoom_drawer/config.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/home/controller/apis.dart';
import 'package:programmerprofile/home/view/widgets/codeforces_graphs.dart';
import 'package:programmerprofile/home/view/widgets/drawer.dart';
import 'package:programmerprofile/home/view/edit_bio_page.dart';
import 'package:programmerprofile/home/view/widgets/lc_tags_chart.dart';
import 'package:programmerprofile/notifications/controller/api.dart';
import 'package:programmerprofile/notifications/view/notification_page.dart';
import '../../auth/model/user.dart';
import 'widgets/github_charts.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = 'home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Home> {
  final ScrollController controller = ScrollController();
  bool githubOn = false;
  bool codeforcesOn = true;
  bool leetcodeOn = false;

  late User? user;
  // List of values: [User object, Map<Date,Contribution>, CFGraphData, GithubData]
  Future<List<dynamic>>? _getData;
  APIs apis = APIs();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // print("did change");
    super.initState();
    _getData = Future.wait([
      apis.getUser(),
      apis.getHeatMapData(),
      apis.getCFGraphData(),
      apis.getGithubData(),
      NotificationAPIs().getNotifications(),
      apis.getLeetCodeData()
    ]);
  }

  @override
  void didChangeDependencies() {
    // print("did change");
    super.didChangeDependencies();
    _getData = Future.wait([
      apis.getUser(),
      apis.getHeatMapData(),
      apis.getCFGraphData(),
      apis.getGithubData(),
      NotificationAPIs().getNotifications(),
      apis.getLeetCodeData()
    ]);
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

  final ZoomDrawerController z = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    // print("BUILDING");
    super.build(context);
    return DrawerTemplate(
        z: z,
        body: Scaffold(
            backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
            body: SafeArea(
                child: Stack(children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      setState(() {
                        _getData = Future.wait([
                          apis.getUser(),
                          apis.getHeatMapData(),
                          apis.getCFGraphData(),
                          apis.getGithubData(),
                          NotificationAPIs().getNotifications(),
                          apis.getLeetCodeData()
                        ]);
                      });
                    },
                  );
                },
                child: FutureBuilder<List<dynamic>>(
                  future: _getData,
                  builder: (ctx, AsyncSnapshot<List<dynamic>> snap) {
                    // print(snap.data);
                    if (snap.hasData) {
                      // print(snap.data);
                      User user = snap.data![0];
                      int numNotifications = snap.data![4] == null
                          ? 0
                          : snap.data![4]["unseen-notifications"];
                      if (snap.data![1] == null &&
                          snap.data![2] == null &&
                          snap.data![3] == null &&
                          snap.data![5] == null) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      IconButton(
                                          onPressed: () {
                                            //print("Pressed");
                                            z.open!();
                                          },
                                          icon: const Icon(Icons.menu,
                                              color: Colors.white)),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            const Color.fromRGBO(0, 10, 56, 1),
                                        child: user.profilePicture == null
                                            ? const Icon(Icons.person)
                                            : Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(user
                                                            .profilePicture!)),
                                                    borderRadius:
                                                        const BorderRadius.all(
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
                                      IconButton(
                                        onPressed: () {},
                                        icon: Stack(
                                          children: <Widget>[
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              NotificationScreen(
                                                                  notifcations:
                                                                      snap.data![
                                                                              4]
                                                                          [
                                                                          "notifications"])));
                                                },
                                                icon: const Icon(
                                                  Icons.notifications,
                                                  color: Colors.white,
                                                )),
                                            numNotifications > 0
                                                ? Positioned(
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth: 12,
                                                        minHeight: 12,
                                                      ),
                                                      child: Text(
                                                        numNotifications
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox()
                                          ],
                                        ),
                                      )
                                    ]),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            //color: Color.fromARGB(255, 125, 10, 48),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            border:
                                                Border.all(color: Colors.grey)),
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
                                              data: user.description == null
                                                  ? "Add profile description in markdown"
                                                  : user.description!,
                                              extensionSet: md.ExtensionSet(
                                                md.ExtensionSet.gitHubFlavored
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
                                                  const EdgeInsets.all(8.0),
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
                              ),
                              const NotFound(),
                            ],
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            snap.data![0] != null
                                ? (Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          IconButton(
                                              onPressed: () {
                                                //print("Pressed");
                                                z.open!();
                                              },
                                              icon: const Icon(Icons.menu,
                                                  color: Colors.white)),
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            foregroundColor:
                                                const Color.fromRGBO(
                                                    0, 10, 56, 1),
                                            child: user.profilePicture == null
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
                                          IconButton(
                                            onPressed: () {},
                                            icon: Stack(
                                              children: <Widget>[
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  NotificationScreen(
                                                                      notifcations:
                                                                          snap.data![4]
                                                                              [
                                                                              "notifications"])));
                                                    },
                                                    icon: const Icon(
                                                      Icons.notifications,
                                                      color: Colors.white,
                                                    )),
                                                numNotifications > 0
                                                    ? Positioned(
                                                        right: 0,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          constraints:
                                                              const BoxConstraints(
                                                            minWidth: 12,
                                                            minHeight: 12,
                                                          ),
                                                          child: Text(
                                                            numNotifications
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 8,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                          )
                                        ]),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                //color: Color.fromARGB(255, 125, 10, 48),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
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
                                                  data: user.description == null
                                                      ? "Add profile description in markdown"
                                                      : user.description!,
                                                  extensionSet: md.ExtensionSet(
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
                                                      const EdgeInsets.all(8.0),
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
                                                                      EditorScreen(
                                                                        initialData:
                                                                            user.description!,
                                                                      )));
                                                        },
                                                        icon: const Icon(
                                                            Icons.edit,
                                                            color:
                                                                Colors.white),
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
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                    color: Colors.transparent),
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
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
                                            githubOn = false;
                                            codeforcesOn = false;
                                            leetcodeOn = true;
                                          });
                                        })
                                  ],
                                ),
                              ),
                            ),
                            snap.data![2] != null && codeforcesOn
                                ? (CodeforcesGraphs(
                                    barGraphData: snap.data![2]["bar"],
                                    donutGraphData: snap.data![2]["donut"],
                                    ratingGraphData: snap.data![2]["rating"],
                                  ))
                                : (snap.data![2] == null && codeforcesOn
                                    ? const NotFound()
                                    : const SizedBox()),
                            snap.data![3] != null && githubOn
                                ? (GitHubCharts(
                                    data: snap.data![3]["details"],
                                    languagedata: snap.data![3]["languageData"],
                                  ))
                                : (snap.data![3] == null && githubOn == true
                                    ? const NotFound()
                                    : const SizedBox()),
                            snap.data![5] != null && leetcodeOn
                                ? LCTagsGraph(
                                    tags: snap.data![5]["tagDetails"],
                                    contests: snap.data![5]["contestHistory"],
                                    languagedata: snap.data![5]
                                        ["languageStats"],
                                  )
                                : (snap.data![5] == null
                                    ? const NotFound()
                                    : const SizedBox())
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: snap.connectionState == ConnectionState.waiting
                          ? LottieBuilder.asset(
                              "assets/images/loading_spinner.json")
                          : const NotFound(),
                    );
                  },
                ),
              ),
            ]))));
  }
}

class NotFound extends StatelessWidget {
  const NotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/images/not-found.json"),
          const Text(
            "No accounts have been connected",
            style: TextStyle(color: Colors.white, fontSize: 25),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Already connected accounts? Pull to refresh",
            style: TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}
