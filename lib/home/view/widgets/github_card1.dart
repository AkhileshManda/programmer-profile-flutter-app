import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';

Widget githubCard1(
    {required String totalCommits,
    required String prs,
    required String issues,
    required String contributedTo}) {
  return GlassmorphicContainer(
    width: 350,
    height: 200,
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
                  "Total Commits : $totalCommits",
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
                  "Total PRs : $prs ",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total Issues : $issues",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Contributed to: $contributedTo",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: FaIcon(
              FontAwesomeIcons.github,
              color: Colors.white,
              size: 100,
            ),
          )
        ],
      ),
    ),
  );
}
