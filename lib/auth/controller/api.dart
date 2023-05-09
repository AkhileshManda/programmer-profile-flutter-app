import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EndPoint {
  ValueNotifier<GraphQLClient> getClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: HttpLink("https://graphenous.azurewebsites.net/graphql"),
        cache: GraphQLCache(),
      ),
    );

    return client;
  }
}
