import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/view/login_page.dart';
import 'package:programmerprofile/styles.dart';

import '../controller/api.dart';
import '../controller/queries.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});
  static const routeName = "reset-password";
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //final TextEditingController _codeCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon = TextEditingController();

  late String _code;
  bool _onEditing = true;

  bool isLoading = false;

  void onResetPressed(
      {required String code,
      required String email,
      required String password,
      required String confirmPassword}) async {
    
    setState(() {
      isLoading = true;
    });

    final EndPoint point = EndPoint();
    ValueNotifier<GraphQLClient> client = point.getClient();

    QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(AuthenticationQueries.resetPassword()),
        variables: {
          "input": {
            'email': widget.email,
            'code': code,
            'password': password,
            'confirmPassword': confirmPassword
          }
        }));

    if (result.hasException) {
      //print(result.exception);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));
      
      setState(() {
        isLoading = false;
      });
      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
      //notifyListeners();
    } else {
      //print(result.data);
      //print("SHEEESH");
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
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
                        LottieBuilder.asset("assets/images/resetPassword.json",
                            height: 350),

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Reset your password",
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
                            "Enter the code you recieved on your email",
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
                                child: VerificationCode(
                                  textStyle: const TextStyle(
                                      fontSize: 20.0, color: Colors.pink),
                                  keyboardType: TextInputType.streetAddress,
                                  underlineColor: Colors.pink,
                                  // If this is null it will use primaryColor: Colors.red from Theme
                                  length: 6,
                                  cursorColor: Colors
                                      .pink, // If this is null it will default to the ambient

                                  onCompleted: (String value) {
                                    setState(() {
                                      _code = value;
                                    });
                                  },
                                  onEditing: (bool value) {
                                    setState(() {
                                      _onEditing = value;
                                    });
                                    if (!_onEditing){
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    textAlign: TextAlign.center,
                                    "Enter new password",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _passwordCon,
                                  obscureText: true,
                                  decoration: Styles.textFieldStyle("Password"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _confirmPasswordCon,
                                  obscureText: true,
                                  decoration:
                                      Styles.textFieldStyle("Confirm Password"),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
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
                                  onResetPressed(
                                    code: _code,
                                    email: widget.email,
                                    password: _passwordCon.text,
                                    confirmPassword: _confirmPasswordCon.text,
                                  );
                                },
                                child: const Text(
                                  "Reset my password",
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
