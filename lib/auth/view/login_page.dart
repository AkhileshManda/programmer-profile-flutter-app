import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/controller/api.dart';
import 'package:programmerprofile/auth/view/forgot_password_page.dart';
import 'package:programmerprofile/auth/view/sign_up_page.dart';
import 'package:programmerprofile/styles.dart';
import 'package:programmerprofile/temp_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/queries.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = 'login_screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  void onLoginPressed({required String email, required String password}) async {
    final EndPoint point = EndPoint();
    ValueNotifier<GraphQLClient> client = point.getClient();

    QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(AuthenticationQueries.signIn()),
        variables: {
          "input": {
            'email': email,
            'password': password,
          }
        }));

    if (result.hasException) {
      //print(result.exception);

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
      //notifyListeners();
    } else {
      //print(result.data);
      final prefs = await SharedPreferences.getInstance();
      //print(result.data!['signin']['token']);
      prefs.setString("token", result.data!['signin']['token']);
      //print(prefs.getString("token"));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Home.routeName);
      //print("SHEEESH");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: Stack(
          children: [
            LottieBuilder.asset("assets/animations/bg-1.json"),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LottieBuilder.asset(
                            "assets/images/67011-code-time.json",
                            height: 350),

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Let's get you logged in",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Expanded(child: Container()),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _emailCon,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: Styles.textFieldStyle("Email"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _passwordCon,
                                  obscureText: true,
                                  decoration: Styles.textFieldStyle("Password"),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        ForgotPasswordScreen.routeName);
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.pink),
                                  )),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.pink)),
                                onPressed: () {
                                  onLoginPressed(
                                      email: _emailCon.text,
                                      password: _passwordCon.text);
                                },
                                child: const Text(
                                  "Log in",
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "New User?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, SignUpScreen.routeName);
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 17),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
