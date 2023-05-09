class SearchQuery {
  static String searchQuery() {
    return """ 
      query Search(\$input: SearchInput!) {
        search(input: \$input) {
          id
          name
          email
          profilePicture
          description
          isFollowing
        }
      }
     """;
  }

  static String toggleFollow() {
    return """ 
    mutation ToggleFollow(\$input: ToggleFollowInput!) {
    toggleFollow(input: \$input)
   } 
    """;
  }
}
