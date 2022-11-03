import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:programmerprofile/contests/controller/query.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/contest_model.dart';

class ContestAPI{
  Future<List<List<Contest>>?> getContests() async {
    //print("Called");
    List<List<Contest>> data = [];

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    //print("token: $token");
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(ContestQuery.getContests()),
    ));
    if (result.hasException) {
      //print("Contest Exception");
     
      if (result.exception!.graphqlErrors.isEmpty) {
       // print("Internet is not found");
      } else {
       // print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
     // print(result.data);
      List<Contest> todayContests = [];
      List<Contest> tomContests = [];
      List<Contest> weekContests = [];
      List<Contest> upcomingContests = [];

      for(var x in result.data!["getContests"]["today"]) {
        todayContests.add(Contest(
          duration: x["duration"], 
          // start: DateTime.parse(x["start"].toString()), 
          // end: DateTime.parse(x["end"].toString()),
          event: x["event"], 
          host: x["host"], 
          href: x["href"], 
          id: x["id"], 
          resource: x["resource"], 
          resourceId: x["resource_id"]));
      }
      //print("today fetched");
      for(var x in result.data!["getContests"]["tomorrow"]) {
        tomContests.add(Contest(
          duration: x["duration"], 
          start: DateTime.parse(x["start"].toString()), 
          end: DateTime.parse(x["end"].toString()),
          event: x["event"], 
          host: x["host"], 
          href: x["href"], 
          id: x["id"], 
          resource: x["resource"], 
          resourceId: x["resource_id"]));
      }
      //print("tom fetched");

      for(var x in result.data!["getContests"]["week"]) {
       weekContests.add(Contest(
          duration: x["duration"], 
          start: DateTime.parse(x["start"].toString()), 
          end: DateTime.parse(x["end"].toString()),
          event: x["event"], 
          host: x["host"], 
          href: x["href"], 
          id: x["id"], 
          resource: x["resource"], 
          resourceId: x["resource_id"]));
      }
      //print("week fetched");

      for(var x in result.data!["getContests"]["upcoming"]) {
        upcomingContests.add(Contest(
          duration: x["duration"], 
          start: DateTime.parse(x["start"].toString()), 
          end: DateTime.parse(x["end"].toString()), 
          event: x["event"], 
          host: x["host"], 
          href: x["href"], 
          id: x["id"], 
          resource: x["resource"], 
          resourceId: x["resource_id"]));
      }
      //print("upcoming fetched");

      
      // data.putIfAbsent("today", () => todayContests);
      // data.putIfAbsent("tom", () => tomContests);
      // data.putIfAbsent("week", () => weekContests);
      // data.putIfAbsent("upcoming", () => upcomingContests);
      //print(data.toString());
      data.add(todayContests);
      data.add(tomContests);
      data.add(weekContests);
      data.add(upcomingContests);
      return data;
    }
    return null;
  }
}