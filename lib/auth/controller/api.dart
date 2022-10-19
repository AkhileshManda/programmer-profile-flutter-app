import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EndPoint {

  ValueNotifier<GraphQLClient> getClient(){
    ValueNotifier<GraphQLClient> _client = ValueNotifier(
      GraphQLClient(
        link: HttpLink("https://programmer-profile.azurewebsites.net/graphql"),
        cache: GraphQLCache(),
      )
    );

    return _client;
  }
}