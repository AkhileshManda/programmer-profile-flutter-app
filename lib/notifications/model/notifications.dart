class NotificationModel {
  String id;
  String description;
  //DateTime createdAt;
  String notificationType;
  bool status;
  //DateTime? seenAt;
  NotificationUser user;
  NotificationUser otherUser;

  NotificationModel({
    required this.id,
    required this.description,
    //required this.createdAt,
    required this.notificationType,
    required this.status,
    //this.seenAt,
    required this.user,
    required this.otherUser,
  });
}

class NotificationUser {
  String id;
  String name;
  String? profile;
  String? description;
  NotificationUser({
    required this.id,
    required this.name,
    this.profile,
    this.description,
  });
}
