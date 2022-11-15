import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import '../src/graphql_requests.dart';


class User extends ChangeNotifier {
  int id;
  String name;
  String avatar;
  String bannerImage;
  User({this.id = -1, this.name = '', this.avatar = '', this.bannerImage = ''}){
    notifyListeners();
  }

  void updateId(id) {
    this.id = id;
    notifyListeners();
  }

  void updateName(name) {
    this.name = name;
    notifyListeners();
  }

  void updateAvatar(avatar) {
    this.avatar = avatar;
    notifyListeners();
  }

  void updateBannerImage(bannerImage) {
    this.bannerImage = bannerImage;
    notifyListeners();
  }

  void initUser() async {
    QueryResult viewer = await GqlQuery.getViewer();
    if (viewer.hasException) {
    } else {
      id = viewer.data?['Viewer']['id'];
      name = viewer.data?['Viewer']['name'];
      avatar = viewer.data?['Viewer']['avatar']['medium'];
      bannerImage = viewer.data?['Viewer']['bannerImage'];
      notifyListeners();
    }
  }
}