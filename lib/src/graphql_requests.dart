import 'package:graphql/client.dart';
import 'client.dart';

class GqlQuery {
  static Future<QueryResult> getViewer() async {
    String query = '''
                query {
                  Viewer {
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
                          score(format: POINT_10_DECIMAL)
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
                            synonyms
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

  static Future<QueryResult> saveMediaListEntryScore(id, score) async {
    String query = r'''
                mutation ($id: Int, $score: Float){
                  SaveMediaListEntry(id: $id, score: $score){
                    id
                    score
                  }
                }
    ''';

    MutationOptions options = MutationOptions(
      document: gql(query),
      variables: <String, dynamic>{'id': id, 'score': score},
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