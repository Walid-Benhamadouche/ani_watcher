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

  static Future<QueryResult> getAnimeList(id, network, status) async {
    String query = r'''
                query($id: Int, $status: MediaListStatus) {
                  MediaListCollection (userId: $id, type: ANIME, status: $status) {
                    lists{
                      entries{
                          id
                          media{
                            id
                            format
                            season
                            seasonYear
                            episodes
                            bannerImage
                            genres
                            meanScore
                            description
                            status
                            studios{
                              nodes{
                                name
                              }
                            }
                            mediaListEntry{
                              status
                              progress
                            }
                            nextAiringEpisode{
                              episode
                              timeUntilAiring
                            }
                            title{
                              english
                              romaji
                              native
                              userPreferred
                            }
                            coverImage{
                              large
                            }
                          }
                        }
                    }
                  }
                }
                ''';
    if (network == false) {
      QueryOptions options = QueryOptions(
        document: gql(query),
        variables: <String, dynamic>{
          'id': id,
          'status': status,
          //'version': 2,
        },
      );
      return await GQLClient.client.query(options);
    } else {
      QueryOptions options = QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(query),
        variables: <String, dynamic>{
          'id': id,
        },
      );
      return await GQLClient.client.query(options);
    }
  }

  static Future<QueryResult> addMediaListEntry(mediaId, status) async {
    String query = r'''
                mutation ($mediaId: Int, $status: MediaListStatus){
                  SaveMediaListEntry(mediaId: $mediaId, status: $status){
                    mediaId
                    status
                  }
                }
    ''';

    MutationOptions options = MutationOptions(
      document: gql(query),
      variables: <String, dynamic>{'mediaId': mediaId, 'status': status},
    );

    return await GQLClient.client.mutate(options);
  }

  static Future<QueryResult> saveMediaListEntryProgress(id, progress) async {
    String query = r'''
                mutation ($id: Int, $progress: Int){
                  SaveMediaListEntry(id: $id, progress: $progress){
                    id
                    progress
                  }
                }
    ''';

    MutationOptions options = MutationOptions(
      document: gql(query),
      variables: <String, dynamic>{'id': id, 'progress': progress},
    );

    return await GQLClient.client.mutate(options);
  }

  static Future<QueryResult> saveMediaListEntryStatus(id, status) async {
    String query = r'''
                mutation ($id: Int, $status: MediaListStatus){
                  SaveMediaListEntry(id: $id, status: $status){
                    id
                    status
                  }
                }
    ''';

    MutationOptions options = MutationOptions(
      document: gql(query),
      variables: <String, dynamic>{'id': id, 'status': status},
    );

    return await GQLClient.client.mutate(options);
  }

  static Future<QueryResult> getSeasonAnimeList(
      season, seasonYear, network) async {
    String query = r'''
                query($id: Int, $season: MediaSeason, $seasonYear: Int) {
                  Page(page: 1, perPage: 50) {
                    media (id: $id, season: $season, seasonYear: $seasonYear, type: ANIME){
                            id
                            format
                            season
                            seasonYear
                            episodes
                            bannerImage
                            genres
                            meanScore
                            description
                            studios{
                              nodes{
                                name
                              }
                            }
                            mediaListEntry{
                              status
                              progress
                            }
                            nextAiringEpisode{
                              episode
                              timeUntilAiring
                            }
                            title{
                              english
                              romaji
                              native
                              userPreferred
                            }
                            coverImage{
                              large
                            }
                          }
                  }
                }
                
                ''';
    if (network == false) {
      QueryOptions options = QueryOptions(
        document: gql(query),
        variables: <String, dynamic>{
          'season': season,
          'seasonYear': seasonYear,
        },
      );
      return await GQLClient.client.query(options);
    } else {
      QueryOptions options = QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(query),
        variables: <String, dynamic>{
          'season': season,
          'seasonYear': seasonYear,
        },
      );
      return await GQLClient.client.query(options);
    }
  }

  // Search for anime
  static Future<QueryResult> searchAnime(
      search, network) async {
    String query = r'''
                query($id: Int, $search: String) {
                  Page(page: 1, perPage: 50) {
                    media (id: $id, search: $search, type: ANIME){
                            id
                            format
                            season
                            seasonYear
                            episodes
                            bannerImage
                            genres
                            meanScore
                            description
                            studios{
                              nodes{
                                name
                              }
                            }
                            mediaListEntry{
                              status
                              progress
                            }
                            nextAiringEpisode{
                              episode
                              timeUntilAiring
                            }
                            title{
                              english
                              romaji
                              native
                              userPreferred
                            }
                            coverImage{
                              large
                            }
                          }
                  }
                }
                
                ''';
    if (network == false) {
      QueryOptions options = QueryOptions(
        document: gql(query),
        variables: <String, dynamic>{
          'search': search,
        },
      );
      return await GQLClient.client.query(options);
    } else {
      QueryOptions options = QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(query),
        variables: <String, dynamic>{
          'search': search,
        },
      );
      return await GQLClient.client.query(options);
    }
  }
}