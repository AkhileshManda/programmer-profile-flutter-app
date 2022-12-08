class NotificationQuery {
  static String notifications() {
    return """ 
    query Notifications {
  notifications {
    notifications {
      id
      description
      createdAt
      seenAt
      seenStatus
      User {
        id
        name
        profilePicture
        description
      }
      notificationType
      OtherUser {
        id
        name
        profilePicture
        description
      }
    }
    unseenNotifications
  }
}

    """;
  }

  static String seeNotifications() {
    return """ 
    mutation SeeNotification(\$input: SeeNotificationInput!) {
  seeNotification(input: \$input)
}
  
    """;
  }
}
