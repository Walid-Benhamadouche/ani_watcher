import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

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
  static var client = MyOAuth2Client(
      redirectUri: 'com.desire.anime://auth',
      customUriScheme: 'com.desire.anime');

  static OAuth2Helper oauth2Helper = OAuth2Helper(
    client,
    grantType: OAuth2Helper.AUTHORIZATION_CODE,
    clientId: '6771',
    clientSecret: 'RQf3L2RaW1am3Gv2ssVZFnENODw4sBD74Tgy4crZ',
  );

  checkAccessToken() async {
    var resp = await oauth2Helper.getTokenFromStorage();
    return resp?.accessToken;
  }

  getAccessToken() async {
    var resp = await oauth2Helper.getToken();
    return resp?.accessToken;
  }
}
