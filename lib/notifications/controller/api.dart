import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:programmerprofile/notifications/controller/queries.dart';
import 'package:programmerprofile/notifications/model/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/controller/client.dart';

class NotificationAPIs {
  Future<Map<String, dynamic>?> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;

    Map<String, dynamic> data = {};

    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);
    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(NotificationQuery.notifications()),
    ));

    if (result.hasException) {
      //print("Notification DED");

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print("Notification Success");
      //print(result.data);

      List<NotificationModel> notifications = [];
      for (var x in result.data!["notifications"]["notifications"]) {
        //print( x["User"]["id"] + " "+x["User"]["name"]+" "+x["User"]["profilePicture"]);
        //print(x["OtherUser"].toString());
        //print(x["OtherUser"]["id"] + " "+x["OtherUser"]["name"]+" "+x["OtherUser"]["profilePicture"]);
        notifications.add(NotificationModel(
          id: x["id"],
          description: x["description"],
          //createdAt: DateTime.parse(x["createdAt"].toString()),
          //seenAt: DateTime.parse(x["seenAt"].toString()),
          notificationType: x["notificationType"],
          status: x["seenStatus"],
          user: NotificationUser(
            id: x["User"]["id"],
            name: x["User"]["name"],
            profile: x["User"]["profilePicture"],
            description: x["User"]["description"],
          ),
          otherUser: NotificationUser(
              id: x["OtherUser"]["id"],
              name: x["OtherUser"]["name"],
              profile: x["OtherUser"]["profilePicture"],
              description: x["OtherUser"]["description"]),
        ));
      }
      //print("here");
      //print(notifications.toString());
      data.putIfAbsent("notifications", () => notifications);
      data.putIfAbsent("unseen-notifications",
          () => result.data!["notifications"]["unseenNotifications"]);
      return data;
    }
    return null;
    //Navigator.pushReplacementNamed(context, Home.routeName);
  }

  Future<void> markAsRead(String notificationID) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;

    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);
    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(NotificationQuery.seeNotifications()),
      variables:  {
          "input": {
            "notificationId": notificationID
          }
        }
    ));

    if (result.hasException) {
      //print("Notification DED");

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print("Notification Success");
      //print(result.data);
      //print("Notification Success");
    }
  }
}
