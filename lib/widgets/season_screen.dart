import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '../src/authentication_controller.dart';
import '../src/client.dart';
import '../src/anime.dart';
import '../src/graphql_requests.dart';

import 'components/drawer_widget.dart';
import 'components/search_widget.dart';
import 'components/anime_card_discover_widget.dart';

class SeasonScreen extends StatefulWidget {
  SeasonScreen({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _SeasonScreenState createState() => _SeasonScreenState();
}

class _SeasonScreenState extends State<SeasonScreen> {
  dynamic queryList;
  List<Anime> animelist = [];
  int id = -1;
  String name = '';
  String avatar = '';
  String bannerImage = '';
  String season = 'WINTER';
  DateTime now = DateTime.now();
  int year = 0;
  @override
  void initState() {
    year = now.year;
    super.initState();
  }

  Future initApp() async {
    await AuthenticationController.isTokenPresent();
    if (AuthenticationController.isAuthenticated) {
      var accessToken = await AuthenticationController.authenticate();
      await GQLClient.initClient(accessToken: accessToken);
    
      QueryResult viewer = await GqlQuery.getViewer();
      if (viewer.hasException) {
        name = viewer.exception.toString();
      } else {
        id = viewer.data?['Viewer']['id'];
        name = viewer.data?['Viewer']['name'];
        avatar = viewer.data?['Viewer']['avatar']['medium'];
        bannerImage = viewer.data?['Viewer']['bannerImage'];
      }
    }
    QueryResult queryListRes =
        await GqlQuery.getSeasonAnimeList(season, year, false);
    if (queryListRes.hasException) {
    } else {
      queryList = queryListRes.data?['Page']['media'] as List<dynamic>;
    }
    Provider.of<AnimeList>(context, listen: false).clearList(5);
    for (var item in queryList) {
      Provider.of<AnimeList>(context, listen: false).addAnime(5, Anime(item: item, boolV: true));
    }
  }

  Future _refresh() async {
    QueryResult queryListRes =
        await GqlQuery.getSeasonAnimeList(season, year, true);
    if (queryListRes.hasException) {
    } else {
      queryList = queryListRes.data?['Page']['media'] as List<dynamic>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Container());
          } else {
            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Container(
                    height: 33,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Search(),
                  ),
                ),
                body: OrientationBuilder(
                  builder: (context, orientation) {
                    int maxLine;
                    maxLine = 14;
                    List<List<Anime>>temp = Provider.of<AnimeList>(context).animes;
                    return SafeArea(
                        child: RefreshIndicator(
                          color: Colors.blue,
                            onRefresh: _refresh,
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () { setState(() {
                                      season = 'WINTER';
                                    });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text("Winter",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),)
                                    ),
                                  InkWell(
                                    onTap: () { setState(() {
                                      season = 'SPRING';
                                    });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text("Spring",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),)
                                    ),
                                  InkWell(
                                    onTap: () { setState(() {
                                      season = 'SUMMER';
                                    });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text("Summer",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),)
                                    ),
                                  InkWell(
                                    onTap: () { setState(() {
                                      season = 'FALL';
                                    });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text("Fall",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))))
                                    ),
                                  DropdownButton<String>(
                                      value: ' $year',
                                      onChanged: (String? val) {setState(() {
                                        year = int.parse(val!);
                                      });},
                                      items: List<int>.generate(
                                        2022-1960+1, 
                                        (int index) => 2022 - index).map<DropdownMenuItem<String>>((int value) {
                                          return DropdownMenuItem<String>(
                                              value: ' $value', child: Text(' $value'));
                                        }).toList(),)
                              ],),
                              Flexible(child: 
                              GridView.count(
                                physics: const AlwaysScrollableScrollPhysics(),
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 2.7),
                                crossAxisCount: 1,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 5,
                                children: temp[5].map<Widget>((anime) => AnimeCardDiscover(
                                  index: temp[5].indexOf(anime),
                                  anime: anime,
                                  maxLine: maxLine,
                                  type: 5,
                                ))
                            .toList(),
                            ),)])));
                  },
                ),
                drawer: DrawerC(bannerImage: bannerImage, name: name, avatar: avatar,)
                );
          }
        });
  }
}
