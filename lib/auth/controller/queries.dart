class AuthenticationQueries {
  static String signup() {
    return """
        mutation Signup(\$input: SignupInput!) {
            signup(input: \$input) 
        }
    """;
  }

  static String verify() {
    return """ 
      mutation CheckCode(\$input: CheckCodeInput!) {
         checkCode(input: \$input) {
            token
            user {
              email
            name
          }
        }
      }
    """;
  }

  static String signIn() {
    return """ 
    mutation Signin(\$input: SigninInput!) {
      signin(input: \$input) {
        token
        user {
          id
          name
        }
      }
    }  
    """;
  }

  static String forgotPassword() {
    return """ 
      mutation ForgotPassword(\$input: ForgotPasswordInput!) {
        forgotPassword(input: \$input)
      }
    """;
  }

  static String resetPassword() {
    return """ 
     mutation ResetPassword(\$input: ResetPasswordInput!) {
        resetPassword(input: \$input)
      }
    """;
  }
}
