import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/contests/controller/api.dart';
import 'package:programmerprofile/contests/view/contest_card.dart';
import '../../home/view/widgets/drawer.dart';
import '../model/contest_model.dart';

class ContestsScreen extends StatefulWidget {
  const ContestsScreen({super.key});
  static const routeName = 'contests';
  @override
  State<ContestsScreen> createState() => _ContestsScreenState();
}

class _ContestsScreenState extends State<ContestsScreen> {
  late final List<Contest> _contests;
  // This list holds the data for the list view
  List<Contest> _foundContests = [];
  late Future<List<Contest>> _future;

  @override
  void initState() {
    super.initState();
    _future = ContestAPI().getContests();
  }

  void _runFilter(String enteredKeyword) {
    List<Contest> results = [];
    if (enteredKeyword.isEmpty) {
      results = _contests;
    } else {
      results = _contests
          .where((contest) =>
              contest.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              contest.site.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundContests = results;
    });
  }

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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) => _runFilter(value),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Search',
                            suffixIcon: Icon(Icons.search)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Center(
                        child: FutureBuilder<List<Contest>>(
                            future: _future,
                            builder: (ctx, AsyncSnapshot<List<Contest>> snap) {
                              //print(snap.data.toString());

                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (snap.hasData) {
                                //print(snap.data);
                                _foundContests = snap.data!;
                                return Column(
                                  children: [
                                    Expanded(
                                      child: _foundContests.isNotEmpty
                                          ? ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: _foundContests.length,
                                              itemBuilder: (ctx, index) {
                                                return contestCard(
                                                  name: _foundContests[index]
                                                      .name,
                                                  start: _foundContests[index]
                                                      .start,
                                                  end:
                                                      _foundContests[index].end,
                                                  site: _foundContests[index]
                                                      .site,
                                                );
                                              })
                                          : const Text(
                                              'No results found',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                    ),
                                  ],
                                );
                              }
                              return const Text(
                                'No results found',
                                style: TextStyle(fontSize: 24),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
