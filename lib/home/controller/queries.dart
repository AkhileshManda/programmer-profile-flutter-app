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

  static String getUser() {
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

  static String getContributions() {
    return """ 
    query ContributionGraph {
      contributionGraph {
        contributions {
          date
          githubContributions
          codeforcesContributions
          leetcodeContributions
        }
      }
    }
    """;
  }

  static String addDescription() {
    return """ 
    mutation AddDescription(\$input: DescriptionInput!) {
      addDescription(input: \$input)
    }
    """;
  }

  static String getUserDashboard() {
    return """ 
    query Query {
      getUser {
        name
        description
        email
        profilePicture
      }
    }
    """;
  }

  static String cfGraphs() {
    return """ 
     query CodeforcesGraphs {
      codeforcesGraphs {
        donutGraph {
          problemTagGraph {
            tagName
            problemsCount
          }
        }
        barGraph {
          problemRatingGraph {
            difficulty
            problemsCount
          }
        }
        ratingGraph {
          ratings {
            contestId
            contestName
            handle
            rank
            oldRating
            newRating
          }
        }
      }
    }
    """;
  }

  static String githubGraphs() {
    return """ 
      query GithubGraphs {
        githubGraphs {
          streakGraph {
            currentSteakLength
            longestStreakLength
            longestStreakStartDate
            longestStreakEndDate
            currentStreakStartDate
            totalContributions
          }
          languageGraph {
            name
            color
            size
          }
          statsGraph {
            followers
            following
            repos
            stars
            forkedBy
            watchedBy
            commits
            issues
            contributedTo
            pullRequests
            pullRequestReviews
          }
        }
      }
    """;
  }
}
