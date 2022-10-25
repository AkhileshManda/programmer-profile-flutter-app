class DashBoardQueries {
  static String githubAuth() {
    return """ 
      mutation AuthorizeGithub(\$input: FakeInput) {
        authorizeGithub(input: \$input) {
          url
        }
      }
    """;
  }

  static String addUsername() {
    return """ 
    mutation AddUsername(\$input: AddUsernameInput!) {
      addUsername(input: \$input)
    }
  """;
  }

  static String getUser(){
    return """
      query GetUser {
        getUser {
          name
          profilePicture
          codeforcesUsername
          leetcodeUsername
          githubToken
        }
      }
    """;
  }
}
