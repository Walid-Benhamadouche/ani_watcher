import 'package:oauth2_client/oauth2_client.dart';

///////////////////////  Code  //////////////////////////////////////

class MyOAuth2Client extends OAuth2Client {
  MyOAuth2Client({required String redirectUri, required String customUriScheme})
      : super(
            authorizeUrl:
                'https://anilist.co/api/v2/oauth/authorize', //Your service's authorization url
            tokenUrl:
                'https://anilist.co/api/v2/oauth/token', //Your service access token url
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
}

class Auth {
  getAccessToken() async {
    var client = MyOAuth2Client(
        redirectUri: 'com.desire.anime://auth',
        customUriScheme: 'com.desire.anime');
    try {
      var tknResp = await client.getTokenWithAuthCodeFlow(
        clientId: '6771',
        clientSecret: 'RQf3L2RaW1am3Gv2ssVZFnENODw4sBD74Tgy4crZ',
      );
      print("tkn rsp ${tknResp}");
      print("first ${tknResp.httpStatusCode}");
      print("third ${tknResp.expirationDate}");
      return tknResp;
    } on Exception catch (_) {}
    return null;
  }
}
