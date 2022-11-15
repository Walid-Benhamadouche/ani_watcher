import 'package:graphql/client.dart';
import 'package:path_provider/path_provider.dart';

class GQLClient {
  static dynamic _client;
  static Future<void> initClient({accessToken = '', store}) async {
    if (_client == null) {
      final _httpLink = HttpLink(
        'https://graphql.anilist.co',
      );

      final _authLink = AuthLink(
        getToken: () async => 'Bearer $accessToken',
      );

      final Link _link = _authLink.concat(_httpLink);

      var appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      final store = await HiveStore.open(path: appDocPath);

      final GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(store: store),
        link: _link,
      );
      _client = client;
    }
  }

  static get client {
    return _client;
  }
}
