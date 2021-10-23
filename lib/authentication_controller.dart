import 'package:flutter/material.dart';

import 'auth.dart';

class AuthenticationController {
  static ValueNotifier<bool> _isAuthenticated = ValueNotifier(false);

  static bool get isAuthenticated {
    return _isAuthenticated.value;
  }

  static void init() {}

  static Future<bool> isTokenPresent() async {
    var accessToken = await Auth().checkAccessToken();
    if (accessToken != null) {
      _isAuthenticated = ValueNotifier(true);
    }
    return isAuthenticated;
  }

  static Future<String> authenticate() async {
    String accessToken = await Auth().getAccessToken();
    return accessToken;
  }
}
