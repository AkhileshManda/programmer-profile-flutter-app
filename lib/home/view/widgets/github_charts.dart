import 'package:flutter/material.dart';
import 'package:programmerprofile/home/view/widgets/github_card1.dart';
import 'package:programmerprofile/home/view/widgets/github_streak_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/github_language_model.dart';

class GitHubCharts extends StatefulWidget {
  final Map<String, String> data;
  final List<Language> languagedata;
  const GitHubCharts({required this.data, required this.languagedata, super.key});

  @override
  State<GitHubCharts> createState() => _GitHubChartsState();
}

class _GitHubChartsState extends State<GitHubCharts> {
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Github Analysis",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        Column(
          children: [
            githubCard1(
                totalCommits: widget.data["commits"]!,
                prs: widget.data["pullRequests"]!,
                issues: widget.data["issues"]!,
                contributedTo: widget.data["contributedTo"]!),
            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom:8.0),
              child: GithubStreakGraph(
                currentStreakLength: widget.data["currentStreakLength"]!, 
                longestStreakLength: widget.data["longestStreakLength"]!,
                 currentStreakStartDate: widget.data["currentStreakStartDate"]!, 
                longestStreakStartDate: widget.data["longestStreakStartDate"]!, 
                longestStreakEndDate: widget.data["longestStreakEndDate"]!,
              ),
            ),
            SfCircularChart(
                legend: Legend(isVisible: true),
                tooltipBehavior: _tooltip,
                series: <CircularSeries<Language, String>>[
                  DoughnutSeries<Language, String>(
                    dataSource: widget.languagedata,
                    xValueMapper: (Language data, _) => data.name,
                    yValueMapper: (Language data, _) => data.number,
                  )
                ]),
          ],
        ),
      ],
    );
  }
}
