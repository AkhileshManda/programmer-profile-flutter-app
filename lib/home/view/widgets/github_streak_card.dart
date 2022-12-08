import 'package:flutter/material.dart';

class GithubStreakGraph extends StatelessWidget {
  final String currentStreakLength;
  final String longestStreakLength;
  final String currentStreakStartDate;
  final String longestStreakStartDate;
  final String longestStreakEndDate;
  
  const GithubStreakGraph({super.key, required this.currentStreakLength, required this.longestStreakLength, required this.currentStreakStartDate, required this.longestStreakStartDate, required this.longestStreakEndDate});

  @override
  Widget build(BuildContext context) {
    return  Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.grey)),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Current Streak Start Date ${currentStreakStartDate.substring(0,10)}"),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text("Total Stars Earned : $totalStars"),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Current Streak Length $currentStreakLength"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Longest Streak Start Date ${longestStreakStartDate.substring(0,10)}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Longest Streak End Date ${longestStreakEndDate.substring(0,10)}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Longest Streak length $longestStreakLength"),
              )

            ],
              
          ),
          
        ],
      ),
    ),
  );
  }
}