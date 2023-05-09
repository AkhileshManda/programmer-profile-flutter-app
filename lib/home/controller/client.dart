import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EndPointGithubAuth {
  ValueNotifier<GraphQLClient> getClientGithub(String token) {
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: HttpLink(
        "https://graphenous.azurewebsites.net/graphql",
        defaultHeaders: {
          'Authorization': 'Bearer $token',
        },
      ),
      cache: GraphQLCache(),
    ));

    return client;
  }
}
