class ContestQuery {
  static String getContests() {
    return """ 

    query GetContests {
  getContests {
    today {
      duration
      start
      end
      event
      host
      href
      id
      resource
      resource_id
    }
    tomorrow {
      duration
      start
      end
      event
      host
      id
      resource
      resource_id
      href
    }
    week {
      duration
      start
      end
      event
      host
      href
      id
      resource
      resource_id
    }
    upcoming {
      duration
      start
      end
      event
      host
      href
      id
      resource
      resource_id
    }
  }
}
    
    
    """;
  }
}
