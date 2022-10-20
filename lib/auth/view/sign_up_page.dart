import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/controller/queries.dart';
import 'package:programmerprofile/auth/view/verification_page.dart';
import '../controller/api.dart';
import 'login_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const routeName = "signUpScreen";
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon = TextEditingController();

  bool isLoading = false;
  
  void onSignUpPressed(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    final EndPoint point = EndPoint();
    ValueNotifier<GraphQLClient> client = point.getClient();

    setState(() {
      isLoading = true;
    });

    QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(AuthenticationQueries.signup()),
        variables: {
          "input": {
            'name': name,
            'email': email,
            'password': password,
            'confirmPassword': confirmPassword,
          }
        }));

    if (result.hasException) {
      setState(() {
        isLoading = false;
      });
      //print(result.exception);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
      //notifyListeners();
    } else {
      //print(result.data);
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerificationScreen(
                    email: email,
                  )));
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LottieBuilder.asset("assets/images/17245-code.json",
                            height: 350),

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Sign Up",
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
                            "Welcome! We are happy to have you here",
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
                                  controller: _nameCon,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Name"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _emailCon,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Email"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _passwordCon,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.pink,
                                          )),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Password"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _confirmPasswordCon,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.pink,
                                          )),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Confirm Password"),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
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
                                  //print('pressed');
                                  onSignUpPressed(
                                    name: _nameCon.text,
                                    email: _emailCon.text,
                                    password: _passwordCon.text,
                                    confirmPassword: _confirmPasswordCon.text,
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already a User?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.routeName);
                                },
                                child: const Text(
                                  "Login",
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
