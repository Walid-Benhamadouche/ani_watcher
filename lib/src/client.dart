import 'package:graphql/client.dart';
import 'package:path_provider/path_provider.dart';

class GQLClient {
  static dynamic _client;
  static Future<bool> initClient({accessToken = '', store}) async {
    if (_client == null) {
      var _httpLink = HttpLink(
        'https://graphql.anilist.co',
      );

      var _authLink = AuthLink(
        getToken: () async => 'Bearer $accessToken',
      );

      Link _link = _authLink.concat(_httpLink);

      var appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      var store = await HiveStore.open(path: appDocPath);
      GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(store: store),
        link: _link,
      );
      _client = client;
    }
    return true;
  }

  static get client {
    return _client;
  }

  static clientS(var cli) {
    _client = cli;
  }
}
