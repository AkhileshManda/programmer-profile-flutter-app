import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/home/view/widgets/image_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../auth/model/user.dart';
import '../../styles.dart';
import '../controller/apis.dart';
import '../controller/queries.dart';

class ProfileScreen extends StatefulWidget {
  //final User user;
  const ProfileScreen({
    super.key,
  });
  static const routeName = 'profile_screen';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  List<bool> expanded = [false, false];
  final TextEditingController _leetcodeCon = TextEditingController();
  final TextEditingController _codeforcesCon = TextEditingController();

  late Future<User?> _future;

  void onGithubAuthPressed() async {
    // setState(() {
    //   isLoading = false;
    // });

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.githubAuth()),
    ));

    if (result.hasException) {
      //print(result.exception);
      // setState(() {
      //   isLoading = false;
      // });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));
      //_passwordCon.clear();

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print(result.data);
      String url = result.data!["authorizeGithub"]["url"];
      final Uri uri = Uri.parse(url);

      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
      //Navigator.pushReplacementNamed(context, Home.routeName);
    }
  }

  void onPlatformAddition(
      {required String username, required String platform}) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(DashBoardQueries.addUsername()),
        variables: {
          "input": {
            'username': username,
            'platform': platform,
          }
        }));

    if (result.hasException) {
      //print(result.exception);
      // setState(() {
      //   isLoading = false;
      // });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content:
              Text(result.exception!.graphqlErrors[0].message.toString())));
      //_passwordCon.clear();

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString("token", result.data!['signin']['token']);
      // if (!mounted) return;
      //Navigator.pushReplacementNamed(context, Home.routeName);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.green,
          content: Text("Success!")));
    }
  }

  @override
  void initState() {
    super.initState();
    _future = APIs().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: SafeArea(
          child: Stack(children: [
            LottieBuilder.asset("assets/animations/bg-1.json"),
            FutureBuilder<User?>(
                future: _future,
                builder: (ctx, AsyncSnapshot<User?> snap) {
                  if (snap.hasData) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // LottieBuilder.asset(
                                  //     "assets/images/67011-code-time.json",
                                  //     height: 100),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      color: Colors.white,
                                      icon: const Icon(Icons.arrow_back_ios),
                                      onPressed: () {
                                        //Navigator.pushReplacementNamed(
                                        // context, Home.routeName);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  ImageInput(url: snap.data!.profilePicture),

                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snap.data!.username!,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 229, 241, 246),
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                  //Expanded(child: Container()),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Styles.githubColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: ListTile(
                                          leading: const FaIcon(
                                              FontAwesomeIcons.github,
                                              color: Colors.white),
                                          title: const Text(
                                            "Authorize with GitHub",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          trailing: snap.data!.githubToken !=
                                                  null
                                              ? const FaIcon(
                                                  FontAwesomeIcons.check,
                                                  color: Colors.green)
                                              : const FaIcon(
                                                  FontAwesomeIcons.plus,
                                                  color: Colors.white),
                                          onTap: () {
                                            if (snap.data!.githubToken ==
                                                null) {
                                              onGithubAuthPressed();
                                            }
                                          }),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Problem Solving Profiles",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExpansionPanelList(
                                        dividerColor: Colors.white,
                                        expandedHeaderPadding:
                                            const EdgeInsets.all(8),
                                        expansionCallback:
                                            (panelIndex, isExpanded) {
                                          setState(() {
                                            expanded[panelIndex] = !isExpanded;
                                          });
                                        },
                                        children: [
                                          ExpansionPanel(
                                              backgroundColor: Colors.pink,
                                              headerBuilder: (context, isOpen) {
                                                return const Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Text(
                                                        "Add Codeforces Username",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17)));
                                              },
                                              body: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        child: TextField(
                                                          controller:
                                                              _codeforcesCon,
                                                          decoration: Styles
                                                              .textFieldStyle(snap
                                                                          .data!
                                                                          .codeforcesUsername ==
                                                                      null
                                                                  ? "Enter Username"
                                                                  : snap.data!
                                                                      .codeforcesUsername!),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(const Color
                                                                            .fromRGBO(
                                                                        0,
                                                                        10,
                                                                        56,
                                                                        1)),
                                                          ),
                                                          onPressed: () {
                                                            onPlatformAddition(
                                                                username:
                                                                    _codeforcesCon
                                                                        .text,
                                                                platform:
                                                                    "CODEFORCES");
                                                          },
                                                          child: Text(
                                                              snap.data!.codeforcesUsername ==
                                                                      null
                                                                  ? "Add"
                                                                  : "Update",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              isExpanded: expanded[0]),
                                          ExpansionPanel(
                                              backgroundColor: Colors.pink,
                                              headerBuilder: (context, isOpen) {
                                                return const Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Text(
                                                        "Add Leetcode Username",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17)));
                                              },
                                              body: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        child: TextField(
                                                          controller:
                                                              _leetcodeCon,
                                                          decoration: Styles
                                                              .textFieldStyle(snap
                                                                          .data!
                                                                          .leetcodeUsername ==
                                                                      null
                                                                  ? "Enter Username"
                                                                  : snap.data!
                                                                      .leetcodeUsername!),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all(
                                                                      const Color
                                                                              .fromRGBO(
                                                                          0,
                                                                          10,
                                                                          56,
                                                                          1))),
                                                          onPressed: () {
                                                            onPlatformAddition(
                                                                username:
                                                                    _leetcodeCon
                                                                        .text,
                                                                platform:
                                                                    "LEETCODE");
                                                          },
                                                          child: Text(
                                                              snap.data!.leetcodeUsername ==
                                                                      null
                                                                  ? "Add"
                                                                  : "Update",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              isExpanded: expanded[1])
                                        ]),
                                  )
                                ],
                              ),
                            )));
                  }
                  return Center(
                      child: LottieBuilder.asset(
                          "assets/images/loading_spinner.json"));
                })
          ]),
        ));
  }
}
