import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:programmerprofile/home/controller/client.dart';
import 'package:programmerprofile/home/view/temp_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_markdown_editor/simple_markdown_editor.dart';

import '../controller/queries.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);
  static const routeName = 'editor_screen';
  @override
  EditorScreenState createState() => EditorScreenState();
}

class EditorScreenState extends State<EditorScreen> {
  final TextEditingController _controller = TextEditingController();

  void onBioSubmitted(String bio)async{
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token")!;
    final EndPointGithubAuth point = EndPointGithubAuth();
    ValueNotifier<GraphQLClient> client = point.getClientGithub(token);

    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(DashBoardQueries.addDescription()),
       variables: {
          "input": {
            "description": bio
          }
        }
    ));

    if (result.hasException) {
      if (!mounted) return null;
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
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Home.routeName);
    }
    return null;

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Markdown Editor"),
        actions: [
          IconButton(
            onPressed: () {
              onBioSubmitted(_controller.text);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MarkdownFormField(
                controller: _controller,
                enableToolBar: true,
                emojiConvert: true,
                autoCloseAfterSelectEmoji: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}