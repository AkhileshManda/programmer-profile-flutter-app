import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/userSearch/view/new_user_page.dart';
import '../controller/api.dart';
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
    //print(widget.notifcations.isEmpty)
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Notification"),
          leading: BackButton(
                          color: Colors.white,
                          onPressed: () {
                            //Navigator.pushReplacementNamed(
                            // context, Home.routeName);
                            Navigator.pop(context);
                          },
                        ),
        ),
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: SafeArea(
          child: Stack(
            children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              widget.notifcations.isNotEmpty? Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        BackButton(
                          color: Colors.white,
                          onPressed: () {
                            //Navigator.pushReplacementNamed(
                            // context, Home.routeName);
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          "Notifications",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.notifcations.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                              tileColor: Colors.white,
                              title:
                                  Text(widget.notifcations[index].description),
                              leading: widget.notifcations[index].otherUser
                                          .profile !=
                                      null
                                  ? Image.network(widget
                                      .notifcations[index].otherUser.profile!)
                                  : const Icon(Icons.person),
                              trailing: SizedBox(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                  onPressed: (){
                                    //print("mark as read");
                                    NotificationAPIs().markAsRead(widget.notifcations[index].id);
                                  },
                                  icon: const Icon(Icons.check_circle),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    ctx,
                                    MaterialPageRoute(
                                        builder: ((context) => NewUserScreen(
                                            id: widget.notifcations[index]
                                                .otherUser.id,
                                            name: widget.notifcations[index]
                                                .otherUser.name,
                                            profilepic: widget
                                                .notifcations[index]
                                                .otherUser
                                                .profile,
                                            description: widget
                                                .notifcations[index]
                                                .otherUser
                                                .description,
                                            isFollowing: true))));
                              });
                        }),
                  )
                ],
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                        child: LottieBuilder.asset("assets/images/4021-no-notification-state.json", height: 250),
                     ),
                  const Text('No notifications for now', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),),
                ],
              ),
            ],
          ),
        ));
  }
}
