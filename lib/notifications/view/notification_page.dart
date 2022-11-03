import 'package:flutter/material.dart';
import '../model/notifications.dart';

class NotificationScreen extends StatefulWidget {
  final List<NotificationModel> notifcations;
  const NotificationScreen({super.key, required this.notifcations});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.notifcations.length,
        itemBuilder: (ctx, index){
          return ListTile(
            title: Text(widget.notifcations[index].description),
          );
        }
      )
    );
  }
}