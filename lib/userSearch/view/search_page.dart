import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/userSearch/controller/apis.dart';
import 'package:programmerprofile/userSearch/model/search_result.dart';
import 'package:programmerprofile/userSearch/view/new_user_page.dart';
import '../../home/view/widgets/drawer.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});
  static const routeName = "user-search";
  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController controller = TextEditingController();
  final ZoomDrawerController z = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return DrawerTemplate(
        z: z,
        body: Scaffold(
            backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
            body: SafeArea(
                child: Stack(children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                    children: [
                      BackButton(
                        color: Colors.white,
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          //onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
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
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<List<SearchResult>?>(
                          future: OtherUserAPIs()
                              .searchResult(searchString: controller.text),
                          builder: ((context, snapshot) {
                            //print(controller.text);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            //print(snapshot.data);
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 2,
                                                color: Colors.amberAccent),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onTap: () {
                                            //print(snapshot.data![index].id);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        NewUserScreen(
                                                          //email: snapshot.data![index].email ,
                                                          name: snapshot
                                                              .data![index].name,
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
                                          tileColor: Colors.white,
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
                                                  foregroundColor: Color.fromRGBO(
                                                      0, 10, 56, 1),
                                                  child: Icon(Icons.person)),
                                          title: Text(snapshot.data![index].name),
                                        ),
                                      );
                                    })),
                              );
                            }
                            return const Center(
                              child: Text("No Results Found"),
                            );
                          }))
                    ],
                  ))
            ]))));
  }
}
