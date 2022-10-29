import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/home/view/widgets/github_card1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controller/queries.dart';
import '../../model/github_language_model.dart';

class GitHubCharts extends StatefulWidget {
  const GitHubCharts({super.key});

  @override
  State<GitHubCharts> createState() => _GitHubChartsState();
}

class _GitHubChartsState extends State<GitHubCharts> {

  Map<String,String> data = {};
  List<Language> languagedata = [];

  Future<Map<String, String>?> getGithubData() async {
    Map<String, String> details = {};
    List<Language> templanguagedata = [];

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.githubGraphs()),
    ));
    if (result.hasException) {
      //print("GITHUB CHARTS");
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));

      if (result.exception!.graphqlErrors.isEmpty) {
        // print("GITHUB CHARTS");
        // print("Internet is not found");
      } else {
        // print("GITHUB CHARTS");
        // print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print(result.data!["codeforcesGraphs"]["barGraph"]["problemRatingGraph"]);

      details.putIfAbsent(
          "currentStreakLength",
          () => result.data!["githubGraphs"]["streakGraph"]
                  ["currentStreakLength"]
              .toString());
      details.putIfAbsent(
          "longestStreakLength",
          () => result.data!["githubGraphs"]["streakGraph"]
                  ["longestStreakLength"]
              .toString());
      details.putIfAbsent(
          "currentStreakStartDate",
          () => result.data!["githubGraphs"]["streakGraph"]
                  ["currentStreakStartDate"]
              .toString());
      details.putIfAbsent(
          "longestStreakStartDate",
          () => result.data!["githubGraphs"]["streakGraph"]
                  ["longestStreakStartDate"]
              .toString());
      details.putIfAbsent(
          "longestStreakEndDate",
          () => result.data!["githubGraphs"]["streakGraph"]
                  ["longestStreakEndDate"]
              .toString());
      details.putIfAbsent(
          "totalContributions",
          () => result.data!["githubGraphs"]["streakGraph"]
                  ["totalContributions"]
              .toString());
      details.putIfAbsent(
          "followers",
          () => result.data!["githubGraphs"]["statsGraph"]["followers"]
              .toString());
      details.putIfAbsent(
          "following",
          () => result.data!["githubGraphs"]["statsGraph"]["following"]
              .toString());
      details.putIfAbsent("repos",
          () => result.data!["githubGraphs"]["statsGraph"]["repos"].toString());
      details.putIfAbsent("stars",
          () => result.data!["githubGraphs"]["statsGraph"]["stars"].toString());
      details.putIfAbsent(
          "forkedBy",
          () => result.data!["githubGraphs"]["statsGraph"]["forkedBy"]
              .toString());
      details.putIfAbsent(
          "watchedBy",
          () => result.data!["githubGraphs"]["statsGraph"]["watchedBy"]
              .toString());
      details.putIfAbsent(
          "commits",
          () =>
              result.data!["githubGraphs"]["statsGraph"]["commits"].toString());
      details.putIfAbsent(
          "issues",
          () =>
              result.data!["githubGraphs"]["statsGraph"]["issues"].toString());
      details.putIfAbsent(
          "pullRequests",
          () =>
              result.data!["githubGraphs"]["statsGraph"]["pullRequests"].toString());
      details.putIfAbsent(
          "pullRequestsReviews",
          () =>
              result.data!["githubGraphs"]["statsGraph"]["pullRequestsReviews"].toString());
      details.putIfAbsent(
          "contributedTo",
          () =>
              result.data!["githubGraphs"]["statsGraph"]["contributedTo"].toString());
      
      for(var x in result.data!["githubGraphs"]["languageGraph"]){
        templanguagedata.add(Language(color: x["color"], name: x["name"], number: x["size"]));
      }
      //print(details.toString());
      data = details;
      languagedata = templanguagedata;
      return details;

    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //getCFGraphDatagetGithubData();
    return FutureBuilder(
        future: getGithubData(),
        builder: (ctx, snap){
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            //return SizedBox();
          }
          if (snap.hasData) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Github Analysis",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                Container(
                  decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    children: [
                      githubCard1(
                        totalStars: data["stars"]!, 
                        totalCommits: data["commits"]!, 
                        prs: data["pullRequests"]!, 
                        issues: data["issues"]!, 
                        contributedTo: data["contributedTo"]!
                      ),

                    SfCircularChart(
                    legend: Legend(isVisible: true),
                    //tooltipBehavior: _tooltip,
                    series: <CircularSeries<Language, String>>[
                      DoughnutSeries<Language, String>(
                        dataSource: languagedata,
                        xValueMapper: (Language data, _) => data.name,
                        yValueMapper: (Language data, _) =>
                            data.number,
                      )
                    ]),

                    ],
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        });
  }
}
