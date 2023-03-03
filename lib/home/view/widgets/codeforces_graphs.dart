import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:programmerprofile/home/model/cf_rating_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/cf_bar_model.dart';
import '../../model/cf_donut_model.dart';

class CodeforcesGraphs extends StatefulWidget {
  final List<CFDonutModel> donutGraphData;
  final List<CFBarModel> barGraphData;
  final List<CFRatingModel> ratingGraphData;
  const CodeforcesGraphs(
      {required this.donutGraphData,
      required this.barGraphData,
      required this.ratingGraphData,
      super.key});

  @override
  State<CodeforcesGraphs> createState() => _CodeforcesGraphsState();
}

class _CodeforcesGraphsState extends State<CodeforcesGraphs> {
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltip1;
  late TooltipBehavior _tooltip2;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    _tooltip1 = TooltipBehavior(enable: true, header: "Rating");
    _tooltip2 = TooltipBehavior(enable: true, header: "Rating");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Codeforces Analysis",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        SfCircularChart(
            tooltipBehavior: _tooltip,
            legend: Legend(isVisible: true, textStyle: const TextStyle(color: Colors.white)),
            series: <CircularSeries<CFDonutModel, String>>[
              DoughnutSeries<CFDonutModel, String>(
                dataSource: widget.donutGraphData,
                xValueMapper: (CFDonutModel data, _) => data.tagName,
                yValueMapper: (CFDonutModel data, _) => data.problemsCount,
              )
            ]),
        SfCartesianChart(
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            tooltipBehavior: _tooltip1,
            
            series: <ChartSeries<CFBarModel, String>>[
              ColumnSeries<CFBarModel, String>(
                dataSource: widget.barGraphData,
                xValueMapper: (CFBarModel data, _) {
                  return data.rating;
                },
                yValueMapper: (CFBarModel data, _) {
                  return data.problemsCount;
                },
              )
            ]),
        SfCartesianChart(
          tooltipBehavior: _tooltip2,
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat("yyyy-MM-dd"),
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
          series: <ChartSeries>[
            LineSeries<CFRatingModel, DateTime>(
                dataSource: widget.ratingGraphData,
                xValueMapper: (CFRatingModel data, _) => data.date,
                yValueMapper: (CFRatingModel data, _) => data.newRating)
          ],
        ),
      ],
    );
  }
}
