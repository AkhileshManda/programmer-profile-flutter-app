class NotificationQuery{
  static String notifications(){
    return """ 
      query Notifications {
        notifications {
          notifications {
            id
            description
            createdAt
            notificationType
            seenStatus
          }
          unseenNotifications
        }
      }
    """;
  }

}