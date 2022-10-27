import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controller/queries.dart';
import '../../model/cf_bar_model.dart';
import '../../model/cf_donut_model.dart';

class CodeforcesGraphs extends StatefulWidget {
  const CodeforcesGraphs({super.key});

  @override
  State<CodeforcesGraphs> createState() => _CodeforcesGraphsState();
}

class _CodeforcesGraphsState extends State<CodeforcesGraphs> {
  late List<CFDonutModel> donutGraphData = [];
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltip1;
  late List<CFBarModel> barGraphData = [];

  Future<List<CFDonutModel>?> getCFGraphData() async {
    List<CFDonutModel> tempdonutGraphData = [];
    List<CFBarModel> tempbarGraphData = [];
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.cfGraphs()),
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
      //print(result.data!["codeforcesGraphs"]["barGraph"]["problemRatingGraph"]);
      for (var x in result.data!["codeforcesGraphs"]["barGraph"]
          ["problemRatingGraph"]) {
        if (x["difficulty"] != null && x["problemsCount"] != null) {
          //print("${x["difficulty"]} ${x["problemsCount"]}");
          tempbarGraphData.add(CFBarModel(
              rating: x["difficulty"].toString(),
              problemsCount: x["problemsCount"]));
        }
      }

      for (var x in result.data!["codeforcesGraphs"]["donutGraph"]
          ["problemTagGraph"]) {
        tempdonutGraphData.add(CFDonutModel(
            tagName: x["tagName"], problemsCount: x["problemsCount"]));
      }
      //print(barGraphData.toString());
      donutGraphData = tempdonutGraphData;
      barGraphData = tempbarGraphData;
      return donutGraphData;
    }
    return null;
  }
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    _tooltip1 = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getCFGraphData();
    return FutureBuilder(
        future: getCFGraphData(),
        builder: (context, snap) {
          if(snap.connectionState == ConnectionState.waiting){
            return const SizedBox();
          }
          if (snap.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Codeforces Analysis",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                SfCircularChart(
                    tooltipBehavior: _tooltip,
                    legend: Legend(isVisible: true),
                    series: <CircularSeries<CFDonutModel, String>>[
                      DoughnutSeries<CFDonutModel, String>(
                        dataSource: donutGraphData,
                        xValueMapper: (CFDonutModel data, _) => data.tagName,
                        yValueMapper: (CFDonutModel data, _) =>
                            data.problemsCount,
                      )
                    ]),
                SfCartesianChart(
                    legend: Legend(isVisible: true),
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    tooltipBehavior: _tooltip1,
                    series: <ChartSeries<CFBarModel, String>>[
                      ColumnSeries<CFBarModel, String>(
                        dataSource: barGraphData,
                        xValueMapper: (CFBarModel data, _) {
                          //print("HERE");
                          return data.rating;
                        },
                        yValueMapper: (CFBarModel data, _) {
                          //print("LMAO");
                          return data.problemsCount;
                        },
                        //name: "String",
                        //color: Colors.red
                      )
                    ])
              ],
            );
          }
          return const Center(child: Text("No data found. Please Add your accounts", style: TextStyle(
            color: Colors.white, fontSize: 16
          )));
        });
  }
}
