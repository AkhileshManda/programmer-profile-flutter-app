import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/lc_contest_model.dart';
import '../../model/lc_language_model.dart';
import '../../model/lc_tags_model.dart';

class LCTagsGraph extends StatefulWidget {
  final List<LCTagsModel> tags;
  final List<LCContest> contests;
  final List<LCLanguage> languagedata;
  const LCTagsGraph({
    required this.tags, 
    required this.contests, 
    required this.languagedata,
    super.key
  });
  @override
  State<LCTagsGraph> createState() => _LCTagsGraphState();
}

class _LCTagsGraphState extends State<LCTagsGraph> {
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltip1;
  late TooltipBehavior _tooltip2;
  @override
  initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    _tooltip1 = TooltipBehavior(enable: true);
    _tooltip2 = TooltipBehavior(enable: true);
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfCircularChart(
            tooltipBehavior: _tooltip2,
            legend: Legend(isVisible: true),
            series: <CircularSeries<LCLanguage, String>>[
              DoughnutSeries<LCLanguage, String>(
                dataSource: widget.languagedata,
                xValueMapper: (data, _) => data.languageName,
                yValueMapper: (data, _) => data.problemsSolved,
              )
          ]),
        SfCircularChart(
            tooltipBehavior: _tooltip,
            legend: Legend(isVisible: true),
            series: <CircularSeries<LCTagsModel, String>>[
              DoughnutSeries<LCTagsModel, String>(
                dataSource: widget.tags,
                xValueMapper: (data, _) => data.tagName,
                yValueMapper: (data, _) => data.problemsCount,
              )
            ]),
        SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
            ),
            primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0)),
            tooltipBehavior: _tooltip1,
            series: <ChartSeries<LCContest, DateTime>>[
              // Renders line chart
              LineSeries<LCContest, DateTime>(
                  dataSource: widget.contests,
                  xValueMapper: (data, _) => data.startTime,
                  yValueMapper: (data, _) => data.rating)
            ]),
        // SfCartesianChart(
        //   tooltipBehavior: _tooltip1,
        //   primaryXAxis: DateTimeAxis(),
        //   series: <ChartSeries>[
        //     LineSeries<LCContest, DateTime>(
        //         dataSource: widget.contests,
        //         xValueMapper: (data, _) => data.startTime,
        //         yValueMapper: (data, _) => data.rating)
        //   ],
        // ),
      ],
    );
  }
}
