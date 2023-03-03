import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/userSearch/controller/apis.dart';
import 'package:programmerprofile/userSearch/model/search_result.dart';
import 'package:programmerprofile/userSearch/view/new_user_page.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});
  static const routeName = "user-search";
  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController controller = TextEditingController();
  OtherUserAPIs apis = OtherUserAPIs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: SafeArea(
            child: Stack(children: [
          LottieBuilder.asset("assets/animations/bg-1.json"),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      //Navigator.pushReplacementNamed(
                      // context, Home.routeName);
                      Navigator.pop(context);
                    },
                  ),
                  const Text("Search Users",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                child: TextField(
                  controller: controller,
                  //onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Search',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        //print(controller.text);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<SearchResult>?>(
                    future: OtherUserAPIs()
                        .searchResult(searchString: controller.text),
                    builder: ((context, snapshot) {
                      //print(controller.text);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LottieBuilder.asset(
                            "assets/images/loading_spinner.json");
                      }
                      //print(snapshot.data);
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                              // shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GlassmorphicContainer(
                                    width: double.infinity,
                                    height: 69,
                                    borderRadius: 20,
                                    blur: 20,
                                    alignment: Alignment.bottomCenter,
                                    border: 2,
                                    linearGradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFFffffff)
                                              .withOpacity(0.1),
                                          const Color(0xFFFFFFFF)
                                              .withOpacity(0.05),
                                        ],
                                        stops: const [
                                          0.1,
                                          1,
                                        ]),
                                    borderGradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFffffff)
                                            .withOpacity(0.5),
                                        const Color((0xFFFFFFFF))
                                            .withOpacity(0.5),
                                      ],
                                    ),
                                    child: Center(
                                      child: ListTile(
                                          onTap: () {
                                            //print(snapshot.data![index].id);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        NewUserScreen(
                                                          //email: snapshot.data![index].email ,
                                                          name: snapshot
                                                              .data![index]
                                                              .name,
                                                          description: snapshot
                                                              .data![index]
                                                              .description,
                                                          id: snapshot
                                                              .data![index].id,
                                                          profilepic: snapshot
                                                              .data![index]
                                                              .photoUrl,
                                                          isFollowing: snapshot
                                                              .data![index]
                                                              .isFollowing,
                                                        )));
                                          },
                                          //tileColor: Colors.white,
                                          leading: snapshot
                                                      .data![index].photoUrl !=
                                                  null
                                              ? CircleAvatar(
                                                  foregroundImage: NetworkImage(
                                                      snapshot.data![index]
                                                          .photoUrl!),
                                                )
                                              : const CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor:
                                                      Color.fromRGBO(
                                                          0, 10, 56, 1),
                                                  child: Icon(Icons.person)),
                                          title: Text(
                                            snapshot.data![index].name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          subtitle: snapshot.data![index]
                                                      .description !=
                                                  null
                                              ? Text(
                                                  snapshot
                                                      .data![index].description!
                                                      .trim(),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : null,
                                          trailing: IconButton(
                                            icon: snapshot
                                                    .data![index].isFollowing
                                                ? const FaIcon(
                                                    FontAwesomeIcons.check,
                                                    color: Colors.green,
                                                    size: 15,
                                                  )
                                                : const Icon(
                                                    Icons.person_add,
                                                    color: Colors.white,
                                                  ),
                                            onPressed: () async {
                                              bool x = await apis.toggleFollow(
                                                  snapshot.data![index]
                                                          .isFollowing
                                                      ? "REMOVE"
                                                      : "ADD",
                                                  snapshot.data![index].id);
                                              if (x) {
                                                setState(() {});
                                              }
                                            },
                                          )),
                                    ),
                                  ),
                                );
                              })),
                        );
                      }
                      return const Center(
                        child: Text("No Results Found"),
                      );
                    })),
              )
            ],
          )
        ])));
  }
}
