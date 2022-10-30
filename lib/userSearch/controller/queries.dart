class SearchQuery {
  static String searchQuery() {
    return """ 
      query Search(\$input: SearchInput!) {
        search(input: \$input) {
          name
          profilePicture
          email
        }
      }
     """;
  }
}
