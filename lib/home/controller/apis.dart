import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:programmerprofile/auth/model/user.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/home/controller/queries.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cf_bar_model.dart';
import '../model/cf_donut_model.dart';
import '../model/cf_rating_model.dart';
import '../model/github_language_model.dart';

class APIs {
  
  Future<Map<String, List<dynamic>>?> getCFGraphData() async {
    Map<String, List<dynamic>>? data = {};
    List<CFDonutModel> tempdonutGraphData = [];
    List<CFBarModel> tempbarGraphData = [];
    List<CFRatingModel> tempRatingData = [];
    
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.cfGraphs()),
    ));
    if (result.hasException) {
      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
        return null;
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

      for (var x in result.data!["codeforcesGraphs"]["ratingGraph"]
          ["ratings"]) {
        tempRatingData.add(CFRatingModel(
          contestId: x["contestId"],
          contestName: x["contestName"],
          handle: x["handle"],
          newRating: x["newRating"],
          oldRating: x["oldRating"],
          rank: x["rank"],
        ));
      }
      //print(barGraphData.toString());
      data.putIfAbsent("donut", () => tempdonutGraphData);
      data.putIfAbsent("bar", () => tempbarGraphData);
      data.putIfAbsent("rating", () => tempRatingData);

      return data;
    }
    return null;
  }

  Future<Map<String,dynamic>?> getGithubData() async {
    Map<String, String> details = {};
    List<Language> templanguagedata = [];
    
    Map<String,dynamic> data = {};
   

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
          () => result.data!["githubGraphs"]["statsGraph"]["pullRequests"]
              .toString());
      details.putIfAbsent(
          "pullRequestsReviews",
          () => result.data!["githubGraphs"]["statsGraph"]
                  ["pullRequestsReviews"]
              .toString());
      details.putIfAbsent(
          "contributedTo",
          () => result.data!["githubGraphs"]["statsGraph"]["contributedTo"]
              .toString());

      for (var x in result.data!["githubGraphs"]["languageGraph"]) {
        templanguagedata.add(
            Language(color: x["color"], name: x["name"], number: x["size"]));
      }
      //print(details.toString());
      data.putIfAbsent("details", () => details);
      data.putIfAbsent("languageData", () => templanguagedata);
      
      return data;
    }
    return null;
  }
 
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.getUserDashboard()),
    ));

    if (result.hasException) {
      //print("USER");
      
      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print(result.data);
      return User(
        username: result.data!["getUser"]["name"],
        description: result.data!["getUser"]["description"],
        email: result.data!["getUser"]["email"],
        profilePicture: result.data!["getUser"]["profilePicture"],
      );
     
      //Navigator.pushReplacementNamed(context, Home.routeName);
    }
    return null;
  }

  Future<Map<DateTime, int>?> getHeatMapData() async {
    Map<DateTime, int>? data = {};
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.getContributions()),
    ));
    if (result.hasException) {
      //print("HEATMAP");    

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      for (var activity in result.data!["contributionGraph"]["contributions"]) {
        int contributionSum = activity["githubContributions"] +
            activity["codeforcesContributions"] +
            activity["leetcodeContributions"];
        //print(activity["date"]+" "+contributionSum.toString() );
        DateTime date = DateFormat("yyyy-MM-dd").parse(activity["date"]);
        data.putIfAbsent(date, () => contributionSum);
      }
      //print(data.toString());
      return data;
    }
    return null;
  }

}
