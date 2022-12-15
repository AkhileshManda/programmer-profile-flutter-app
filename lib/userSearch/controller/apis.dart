import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/home/model/cf_bar_model.dart';
import 'package:programmerprofile/home/model/lc_stats_model.dart';
import 'package:programmerprofile/home/model/lc_tags_model.dart';
import 'package:programmerprofile/userSearch/controller/queries.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/controller/queries.dart';
import '../../home/model/cf_donut_model.dart';
import '../../home/model/cf_rating_model.dart';
import '../../home/model/github_language_model.dart';
import '../../home/model/lc_contest_model.dart';
import '../../home/model/lc_language_model.dart';
import '../model/search_result.dart';

class OtherUserAPIs {
  Future<List<SearchResult>?> searchResult({String? searchString}) async {
    List<SearchResult> results = [];

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(
        MutationOptions(document: gql(SearchQuery.searchQuery()), variables: {
      "input": {
        "query": searchString,
      }
    }));

    if (result.hasException) {
      //print("USER");

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      // print("Search called");
      // print(result.data);
      for (var x in result.data!["search"]) {
        results.add(SearchResult(
          description: x["description"],
          id: x["id"],
          email: x["email"],
          name: x["name"],
          photoUrl: x["profilePicture"],
          isFollowing: x["isFollowing"],
        ));
      }
      return results;
    }
    return null;
  }

  Future<Map<String, List<dynamic>>?> getOtherCFGraphData(String id) async {
    Map<String, List<dynamic>>? data = {};
    List<CFDonutModel> tempdonutGraphData = [];
    List<CFBarModel> tempbarGraphData = [];
    List<CFRatingModel> tempRatingData = [];

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(
        MutationOptions(document: gql(DashBoardQueries.cfGraphs()), variables: {
      "input": {"userId": id}
    }));
    if (result.hasException) {
      // print("CodeForces");
      if (result.exception!.graphqlErrors.isEmpty) {
        // print("Internet is not found");
      } else {
        // print(result.exception!.graphqlErrors[0].message.toString());
        return null;
      }
    } else {
      // print("Success");

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
          date: DateFormat("yyyy-MM-dd").parse(x["date"]),
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

  Future<Map<String, dynamic>?> getOtherGithubData(String id) async {
    Map<String, String> details = {};
    List<Language> templanguagedata = [];
    Map<String, dynamic> data = {};

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(DashBoardQueries.githubGraphs()),
        variables: {
          "input": {"userId": id}
        }));
    if (result.hasException) {
      // print("GITHUB CHARTS");

      if (result.exception!.graphqlErrors.isEmpty) {
        // print("GITHUB CHARTS");
        // print("Internet is not found");
      } else {
        // print("GITHUB CHARTS");
        // print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      // print("Github success");

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

  Future<Map<DateTime, int>?> getOtherHeatMapData(String id) async {
    Map<DateTime, int>? data = {};
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(DashBoardQueries.getContributions()),
        variables: {
          "input": {"userId": id}
        }));
    if (result.hasException) {
      // print("HEATMAP");

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      // print("HeatMap Success");
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

  

  Future<bool> toggleFollow(String action, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(
        MutationOptions(document: gql(SearchQuery.toggleFollow()), variables: {
      "input": {"userId": id, "action": action}
    }));
    if (result.hasException) {
      // print("Toggle Follow");

      if (result.exception!.graphqlErrors.isEmpty) {
        // print("Internet is not found");
      } else {
        // print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      // print(result.data);
      return true;
      //print(data.toString());

    }
    return false;
  }

  Future<Map<String,dynamic>?> getOtherLeetCodeData(String id)async{
    Map<String,dynamic>? data = {};
    
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //final String id = prefs.getString("id")!;
    // print("id: " + id);
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.leetcodeGraph()),
      variables: {
        "input": {
          "userId": id
        }
      }
    ));
    // print("REACHED HERE AFTER QUERY");
    if (result.hasException) {
       //print("LEETCODE CHARTS");

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("LEETCODE CHARTS");
        //print("Internet is not found");
      } else {
        //print("LEETCODE CHARTS");
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    }else{
      //print("LC in");
      List<LCContest> contestHistory = [];
      for(var x in result.data!["leetcodeGraphs"]["contestHistory"]){
        //print(x["contest"]["title"]);
        contestHistory.add(
          LCContest(
            problemSolved: x["problemsSolved"], 
            totalProblems: x["totalProblems"], 
            rating: x["rating"],
            ranking: x["ranking"], 
            title: x["contest"]["title"], 
            startTime: DateTime.parse(x["contest"]["startTime"].toString())
          )
        );
      }
      //print("FINE TILL HERE");
      data.putIfAbsent("contestHistory", () => contestHistory);
      //print(result.data!["leetcodeGraphs"]["user"]["submitStatsGlobal"][0]["count"]);
      data.putIfAbsent("questionsStats", () => LCStats(
        totalProblemsSolved: result.data!["leetcodeGraphs"]["user"]["submitStatsGlobal"][0]["count"], 
        easyProblemsSolved: result.data!["leetcodeGraphs"]["user"]["submitStatsGlobal"][1]["count"], 
        mediumProblemsSolved: result.data!["leetcodeGraphs"]["user"]["submitStatsGlobal"][2]["count"], 
        hardProblemsSolved: result.data!["leetcodeGraphs"]["user"]["submitStatsGlobal"][3]["count"],
        problemsTotal: result.data!["leetcodeGraphs"]["problems"][0]["count"],
        easyTotal:  result.data!["leetcodeGraphs"]["problems"][1]["count"],
        mediumTotal:  result.data!["leetcodeGraphs"]["problems"][2]["count"],
        hardTotal:  result.data!["leetcodeGraphs"]["problems"][3]["count"]
      ));
      //print(data);
      List<LCTagsModel> advancedTags = [];
      //print(result.data!["leetcodeGraphs"]["user"]["tagProblemCounts"]["advanced"]);
      for(var x in result.data!["leetcodeGraphs"]["user"]["tagProblemCounts"]["advanced"]){
        advancedTags.add(LCTagsModel(
          tagName: x["tagName"],
          tagSlug: x["tagSlug"],
          problemsCount: x["problemsSolved"],
        ));
      }

      List<LCTagsModel> intermediateTags = [];
      for(var x in result.data!["leetcodeGraphs"]["user"]["tagProblemCounts"]["intermediate"]){
        intermediateTags.add(LCTagsModel(
          tagName: x["tagName"],
          tagSlug: x["tagSlug"],
          problemsCount: x["problemsSolved"],
        ));
      }

      List<LCTagsModel> fundamentalTags = [];
      for(var x in result.data!["leetcodeGraphs"]["user"]["tagProblemCounts"]["fundamental"]){
        fundamentalTags.add(LCTagsModel(
          tagName: x["tagName"],
          tagSlug: x["tagSlug"],
          problemsCount: x["problemsSolved"],
        ));
      }
      data.putIfAbsent("tagDetails", ()=> fundamentalTags+intermediateTags+advancedTags);
      
      List<LCLanguage> languageStats = [];
      for(var x in result.data!["leetcodeGraphs"]["user"]["languageProblemCount"]){
         languageStats.add(LCLanguage(languageName: x["languageName"], problemsSolved: x["problemsSolved"]));
      }

      data.putIfAbsent("languageStats", ()=>languageStats);
      //print(data["languageStats"]);

      return data;
    }
    return null;
  }  


}
