import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:programmerprofile/notifications/controller/queries.dart';
import 'package:programmerprofile/notifications/model/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/controller/client.dart';

class NotificationAPIs{
  Future<Map<String,dynamic>?> getNotifications()async{
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;

    Map<String,dynamic> data = {};
    
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(NotificationQuery.notifications()),
    ));

    if (result.hasException) {
      // print("Notification DED");

      if (result.exception!.graphqlErrors.isEmpty) {
        // print("Internet is not found");
      } else {
        // print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      // print("Notification Success");
      // print(result.data);
      List<NotificationModel> notifications = [];
      for(var x in result.data!["notifications"]["notifications"]) {
        notifications.add(NotificationModel(
          id: x["id"],
          description: x["description"],
          //createdAt: x["createdAt"],
          notificationType: x["notificationType"],
          status: x["seenStatus"],
        ));
        // print("here");
        //print(notifications.toString());
        data.putIfAbsent("notifications",() => notifications);
        data.putIfAbsent("unseen-notifications",() => result.data!["notifications"]["unseenNotifications"]);
        return data;
      }
      return null;
      //Navigator.pushReplacementNamed(context, Home.routeName);
    }
    return null;
  }
}