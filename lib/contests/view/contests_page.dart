import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../home/view/drawer.dart';
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

  Future? _future;

  @override
  void initState() {
    super.initState();
    _future = getContests();
  }

  Future<List<Contest>> getContests() async {
    _contests = [];
    Uri url1 = Uri.parse("https://kontests.net/api/v1/all");
    var response1 = await http.get(
      url1,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final extractedData1 = json.decode(response1.body);

    for (var x in extractedData1) {
      _contests.add(Contest(
          name: x["name"],
          url: x["url"],
          start: x["start_time"],
          end: x["end_time"],
          duration: x["duration"],
          in24hrs: x["in_24_hours"],
          status: x["status"],
          site: x["site"]));
    }

    //print(_contests.length);
    _foundContests = _contests;
    return _contests;
  }

  void _runFilter(String enteredKeyword) {
    //print(enteredKeyword);
    List<Contest> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _contests;
    } else {
      results = _contests
          .where((contest) =>
              contest.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              contest.site.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundContests = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    //getContests();
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
                        child: FutureBuilder(
                            future: _future,
                            builder: (ctx, snap) {
                              //print(snap.data.toString());
                              if (snap.hasData) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: _foundContests.isNotEmpty
                                          ? ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: _foundContests.length,
                                              itemBuilder: (ctx, index) {
                                                return Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            _foundContests[
                                                                    index]
                                                                .name,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              _foundContests[
                                                                      index]
                                                                  .start),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              _foundContests[
                                                                      index]
                                                                  .end),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              _foundContests[
                                                                      index]
                                                                  .site),
                                                        )
                                                      ],
                                                    ),
                                                  ),
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
                              return const CircularProgressIndicator();
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
