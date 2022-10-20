import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/controller/api.dart';
import 'package:programmerprofile/auth/view/forgot_password_page.dart';
import 'package:programmerprofile/auth/view/sign_up_page.dart';
import 'package:programmerprofile/auth/view/widgets/toasts.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  bool isLoading = false;

  void onLoginPressed(
      {required String email,
      required String password,
      required context}) async {
    setState(() {
      isLoading = true;
    });

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
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));
      _passwordCon.clear();

      
      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print(result.data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", result.data!['signin']['token']);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Home.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                                  print("pressed");
                                  print(isLoading.toString());
                                  onLoginPressed(
                                      email: _emailCon.text,
                                      password: _passwordCon.text,
                                      context: context);
                                },
                                child: !isLoading? const Text(
                                  "Log in",
                                ): const CircularProgressIndicator(
                                  color: Colors.white,
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
