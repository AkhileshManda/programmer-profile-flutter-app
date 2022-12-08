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
    query ContributionGraph(\$input: UserIdInput!) {
  contributionGraph(input: \$input) {
    totalContributions
    totalGithubContributions
    totalCodeforcesContributions
    totalLeetcodeContributions
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
    id
    name
    profilePicture
    email
    description
  }
}
    """;
  }

  static String cfGraphs() {
    return """ 
     query CodeforcesGraphs(\$input: UserIdInput!) {
    codeforcesGraphs(input: \$input) {
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
    barGraph {
      problemRatingGraph {
        difficulty
        problemsCount
      }
    }
    donutGraph {
      problemTagGraph {
        tagName
        problemsCount
      }
    }
  }
}
    """;
  }

  static String githubGraphs() {
    return """ 
     query GithubGraphs(\$input: UserIdInput!) {
  githubGraphs(input: \$input) {
    languageGraph {
      name
      color
      size
    }
    statsGraph {
      followers
      following
      repos
      forkedBy
      watchedBy
      commits
      issues
      contributedTo
      pullRequests
      pullRequestReviews
    }
    streakGraph {
      currentSteakLength
      longestStreakLength
      longestStreakStartDate
      longestStreakEndDate
      currentStreakStartDate
      totalContributions
    }
  }
}
    """;
  }

 static String leetcodeGraph(){
  return """ 
  query LeetcodeGraphs(\$input: UserIdInput!) {
  leetcodeGraphs(input: \$input) {
    contest {
      rating
      ranking
      attendedContestsCount
      totalParticipants
      topPercentage
    }
    contestHistory {
      attended
      problemsSolved
      totalProblems
      rating
      ranking
      contest {
        title
        startTime
      }
    }
    problems {
      difficulty
      count
    }
    user {
      username
      profile {
        realname
        about
        avatar
        skills
        country
        ranking
        categoryDiscussCount
        solutionCount
        reputation
        postViewCount
      }
      languageProblemCount {
        languageName
        problemsSolved
      }
      tagProblemCounts {
        advanced {
          tagName
          tagSlug
          problemsSolved
        }
        intermediate {
          tagName
          tagSlug
          problemsSolved
        }
        fundamental {
          tagName
          tagSlug
          problemsSolved
        }
      }
      problemsSolvedBeatsStats {
        difficulty
        percentage
      }
      submitStatsGlobal {
        difficulty
        count
      }
    }
  }
}
  
  
  """;
 }

  
}
