import 'package:flutter/material.dart';

Widget githubCard1(
    {required String totalStars,
    required String totalCommits,
    required String prs,
    required String issues,
    required String contributedTo}){
  return Container(
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
                child: Text("Total Commits : $totalCommits"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Stars Earned : $totalStars"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total PRs : $prs "),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Issues : $issues"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Contributed to: $contributedTo"),
              )

            ],
              
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.person, size: 100),
          )
        ],
      ),
    ),
  );
}
