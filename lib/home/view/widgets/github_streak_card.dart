import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GithubStreakGraph extends StatelessWidget {
  final String currentStreakLength;
  final String longestStreakLength;
  final String currentStreakStartDate;
  final String longestStreakStartDate;
  final String longestStreakEndDate;

  const GithubStreakGraph(
      {super.key,
      required this.currentStreakLength,
      required this.longestStreakLength,
      required this.currentStreakStartDate,
      required this.longestStreakStartDate,
      required this.longestStreakEndDate});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 350,
      height: 250,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Current Streak Start Date ${currentStreakStartDate.substring(0, 10)}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text("Total Stars Earned : $totalStars"),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Current Streak Length $currentStreakLength",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Longest Streak Start Date ${longestStreakStartDate.substring(0, 10)}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Longest Streak End Date ${longestStreakEndDate.substring(0, 10)}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Longest Streak length $longestStreakLength",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
