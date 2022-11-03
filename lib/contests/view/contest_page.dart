import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cards_reel/sliver_cards_reel.dart';
import 'package:lottie/lottie.dart';

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
    return DrawerTemplate(
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
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          z.toggle!();
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
                                        return index == 0 ? const Center(child: CircularProgressIndicator()) : const SizedBox();
                                      }
                                      if (snap.hasData) {
                                        //print(keys);
                                        return Container(
                                          height: 800,
                                          color: Colors.primaries[Random()
                                              .nextInt(Colors.primaries.length)],
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30, right: 30, top: 30),
                                            child: Column(
                                              children: [
                                                Text(contestTimes[index]),
                                                index!=3? SizedBox(
                                                  height: 400,
                                                  child: ListView.builder(
                                                      //shrinkWrap: true,
                                                      //physics: const BouncingScrollPhysics(),
                                                      itemCount: snap
                                                          .data![index].length,
                                                      itemBuilder: (ctx, i) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Card(
                                                            child: ListTile(
                                                              title: Text(snap
                                                                  .data![index][i]
                                                                  .event),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ):SizedBox(
                                                  height: 600,
                                                  child: ListView.builder(
                                                        //shrinkWrap: true,
                                                        //physics: const BouncingScrollPhysics(),
                                                        itemCount: snap
                                                            .data![index].length,
                                                        itemBuilder: (ctx, i) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Card(
                                                              child: ListTile(
                                                                title: Text(snap
                                                                    .data![index][i]
                                                                    .event),
                                                              ),
                                                            ),
                                                          );
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
