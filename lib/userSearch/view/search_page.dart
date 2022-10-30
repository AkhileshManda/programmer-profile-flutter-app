import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/userSearch/model/search_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/view/widgets/drawer.dart';
import '../controller/queries.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});
  static const routeName = "user-search";
  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController controller = TextEditingController();

  Future<List<SearchResult>?> searchResult({String? searchString}) async {
    List<SearchResult> results = [];

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(
        MutationOptions(document: gql(SearchQuery.searchQuery()), variables: {
      "input": {
        "query": searchString,
      }
    }));

    if (result.hasException) {
      //print("USER");

      if (result.exception!.graphqlErrors.isEmpty) {
        //print("Internet is not found");
      } else {
        //print(result.exception!.graphqlErrors[0].message.toString());
      }
    } else {
      //print(result.data);
      for (var x in result.data!["search"]) {
        results.add(SearchResult(
            email: x["email"], name: x["name"], photoUrl: x["profilePicture"]));
      }
      return results;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DrawerTemplate(
        body: Scaffold(
            backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
            body: SafeArea(
                child: Stack(children: [
              LottieBuilder.asset("assets/animations/bg-1.json"),
              SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const Text("Search Users",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
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
                          future: searchResult(searchString: controller.text),
                          builder: ((context, snapshot) {
                            //print(controller.text);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
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
                                        subtitle:
                                            Text(snapshot.data![index].email),
                                      ),
                                    );
                                  }));
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
