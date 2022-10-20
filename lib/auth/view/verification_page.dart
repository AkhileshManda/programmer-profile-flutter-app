import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/auth/controller/api.dart';
import 'package:programmerprofile/auth/controller/queries.dart';
import 'package:programmerprofile/temp_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});
  static String routeName = 'verification-screen';
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late String _code;
  bool _onEditing = true;

  bool isLoading = false;

  void onVerificationPressed()async{

    setState(() {
      isLoading = true;
    });
    final EndPoint point = EndPoint();
    ValueNotifier<GraphQLClient> client = point.getClient();

    QueryResult result = await client.value.mutate(
        MutationOptions(document: gql(AuthenticationQueries.verify()), 
        variables: {
          "input": {
           'email': widget.email,
           'code': _code
          }
        }));

    if (result.hasException) {
      setState(() {
         isLoading = false;
      });
      //print(result.exception);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));
      if (result.exception!.graphqlErrors.isEmpty) {
        // print("Internet is not found");
      } else {
        // print(result.exception!.graphqlErrors[0].message.toString());
      }
      //notifyListeners();
    } else {
      // print(result.data);
      final prefs = await SharedPreferences.getInstance();
      // print(result.data!['checkCode']['token']);
      prefs.setString("token", result.data!['checkCode']['token']);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Home.routeName);
      // print("SHEEESH");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: Stack(
          children: [
            LottieBuilder.asset("assets/animations/bg-1.json"),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //LottieBuilder.asset("assets/images/112417-verify-your-email.json"),
                    LottieBuilder.asset("assets/images/17245-code.json",
                            height: 350),
                                           const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Verify OTP",
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
                            "Please enter the OTP recieved on your mail to proceed",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(height: 20),
                    VerificationCode(
                      textStyle: const TextStyle(fontSize: 20.0, color: Colors.pink),
                      keyboardType: TextInputType.streetAddress,
                      underlineColor: Colors.pink,
                       // If this is null it will use primaryColor: Colors.red from Theme
                      length: 6,
                      cursorColor:
                          Colors.pink, // If this is null it will default to the ambient
                      // clearAll is NOT required, you can delete it
                      // takes any widget, so you can implement your design
                      clearAll: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'clear all',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                      onCompleted: (String value) {
                        setState(() {
                          _code = value;
                        });
                      },
                      onEditing: (bool value) {
                        setState(() {
                          _onEditing = value;
                        });
                        if (!_onEditing) FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(height: 30,),
                    Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.pink)),
                                onPressed: (){
                                  onVerificationPressed();
                                },
                                child: const Text(
                                  "Verify",
                                )),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
