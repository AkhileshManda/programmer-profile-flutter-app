class NotificationModel{
  String id;
  String description;
  //DateTime createdAt;
  String notificationType;
  bool status;

  NotificationModel({
    required this.id,
    required this.description,
    //required this.createdAt,
    required this.notificationType,
    required this.status
  });
}