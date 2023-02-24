import 'package:flutter/material.dart';
import 'package:flutter_cards_reel/sliver_cards_reel.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/contests/view/contest_card.dart';

import '../../home/view/widgets/drawer.dart';
import '../controller/api.dart';
import '../model/contest_model.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({super.key});
  static const routeName = 'contest_page';
  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  late Future<List<List<Contest>>?> _future;

  @override
  void initState() {
    super.initState();
    _future = ContestAPI().getContests();
  }

  List<String> contestTimes = ["Today", "Tomorrow", "This Week", "Upcoming"];

  @override
  Widget build(BuildContext context) {
    List<Color> contestColors = const [
      Color.fromARGB(255, 86, 18, 247),
      Color.fromARGB(255, 7, 7, 170),
      Color.fromRGBO(127, 22, 127, 1),
      Color.fromRGBO(70, 12, 104, 1)
    ];

    final ZoomDrawerController z = ZoomDrawerController();
    return DrawerTemplate(
      z: z,
      body: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: SafeArea(
          child: Stack(
            children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          //Navigator.pushReplacementNamed(
                          // context, Home.routeName);
                          Navigator.pop(context);
                        },
                      ),
                      const Text("Contests & Events",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ))
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomScrollView(
                        slivers: [
                          SliverCardsReel(
                            itemExtent: 550,
                            itemHeaderExtent: 100,
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder<List<List<Contest>>?>(
                                    future: _future,
                                    builder: (ctx,
                                        AsyncSnapshot<List<List<Contest>>?>
                                            snap) {
                                      //print(snap.data.toString());
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return index == 0
                                            ? Center(child: LottieBuilder.asset(
                                    "assets/images/loading_spinner.json"))
                                            : const SizedBox();
                                      }
                                      if (snap.hasData) {
                                        //print(keys);
                                        return Container(
                                          height: 800,
                                          color: contestColors[index],
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30, right: 30, top: 30),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      Text(contestTimes[index],
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                          )),
                                                ),
                                                index != 3
                                                    ? SizedBox(
                                                        height: 400,
                                                        child: ListView.builder(
                                                            //shrinkWrap: true,
                                                            //physics: const BouncingScrollPhysics(),
                                                            itemCount: snap
                                                                .data![index]
                                                                .length,
                                                            itemBuilder:
                                                                (ctx, i) {
                                                              return Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          8.0),
                                                                  child: contestCard(
                                                                      href: snap.data![index][i].href,
                                                                      name: snap
                                                                          .data![index]
                                                                              [
                                                                              i]
                                                                          .event,
                                                                      start: (snap
                                                                          .data![index]
                                                                              [
                                                                              i]
                                                                          .start!),
                                                                      end: (snap
                                                                          .data![index]
                                                                              [
                                                                              i]
                                                                          .end!),
                                                                      site: snap
                                                                          .data![index]
                                                                              [i]
                                                                          .host));
                                                            }),
                                                      )
                                                    : SizedBox(
                                                        height: 600,
                                                        child: ListView.builder(
                                                            //shrinkWrap: true,
                                                            //physics: const BouncingScrollPhysics(),
                                                            itemCount: snap
                                                                .data![index]
                                                                .length,
                                                            itemBuilder:
                                                                (ctx, i) {
                                                              return Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          8.0),
                                                                  child: contestCard(
                                                                      href: snap.data![index][i].href,
                                                                      name: snap
                                                                          .data![index][
                                                                              i]
                                                                          .event,
                                                                      start: (snap.data![index][i].start ??
                                                                          DateTime
                                                                              .now()),
                                                                      end: (snap.data![index][i].end ??
                                                                          DateTime
                                                                              .now()),
                                                                      site: snap
                                                                          .data![
                                                                              index]
                                                                              [i]
                                                                          .host));
                                                            }),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text(
                                        'No results found',
                                        style: TextStyle(fontSize: 24),
                                      );
                                    },
                                  ),
                                );
                              },
                              childCount: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
