import 'package:graphql/client.dart';
import 'client.dart';

class GqlQuery {
  static Future<QueryResult> getViewer() async {
    String query = '''
                query { # Define which variables will be used in the query (id)
                  Viewer { # Insert our variables into the query arguments (id) (type: ANIME is hard-coded in the query)
                    id
                    name
                    siteUrl
                    bannerImage
                    avatar{
                      medium
                    }
                  }
                }
                ''';
    final QueryOptions options = QueryOptions(
      document: gql(query),
    );
    return await GQLClient.client.query(options);
  }

  static Future<QueryResult> getAnimeList(id) async {
    String query = r'''
                query($id: Int) {
                  MediaListCollection (userId: $id, type: ANIME, status: CURRENT) {
                    lists{
                      entries{
                          id
                          media{
                            id
                            format
                            season
                            seasonYear
                            episodes
                            mediaListEntry{
                              progress
                            }
                            nextAiringEpisode{
                              episode
                              timeUntilAiring
                            }
                            title{
                              english
                            }
                            coverImage{
                              extraLarge
                            }
                          }
                        }
                    }
                  }
                }
                ''';
    QueryOptions options = QueryOptions(
      document: gql(query),
      variables: <String, dynamic>{
        'id': id,
      },
    );
    return await GQLClient.client.query(options);
  }
}
