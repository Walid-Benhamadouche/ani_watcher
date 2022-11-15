import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:project_anime/widgets/components/drawer_widget.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import '../src/anime.dart';
import '../src/user_data.dart';
import '../src/graphql_requests.dart';

import 'components/anime_card_widget.dart';
import 'components/search_widget.dart';
import 'components/shimer_loading_sreen_widget.dart';

@immutable
class MainScreen extends StatefulWidget {
  final String title;
  final String screen;
  final int type;
  MainScreen({required this.title, required this.screen, required this.type});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  dynamic animelist;
  bool refresh = false;
  bool connected = true;
  @override
  void initState() {
    super.initState();
  }

  Future initApp() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
      
        int id = Provider.of<User>(context, listen: false).id;
        if(!refresh){
          QueryResult animeListRes = await GqlQuery.getAnimeList(
            id,
            true, 
            widget.screen);
          if (animeListRes.hasException) {
            print(animeListRes.exception.toString());
          } else {
            animelist = animeListRes.data?['MediaListCollection']['lists'][4 - widget.type]
                ['entries'] as List<dynamic>;
          }
          Provider.of<AnimeList>(context, listen: false).clearList(widget.type);
          if(animelist != null){
            for (var item in animelist) {
              Provider.of<AnimeList>(context, listen: false).addAnime(widget.type, Anime(item: item, boolV: false));
            }
          }
          else {
            print("null");
          }
        }
        refresh = false;
        }
        } on SocketException catch (_) {
          connected = false;
        }
  }

  Future _refresh() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
        QueryResult animeListRes = await GqlQuery.getAnimeList(
          Provider.of<User>(context, listen: false).id, 
          true, 
          widget.screen);
        if (animeListRes.hasException) {
        } else {
          setState(() => animelist = animeListRes.data?['MediaListCollection']
              ['lists'][4 - widget.type]['entries'] as List<dynamic>);
        }
        Provider.of<AnimeList>(context, listen: false).clearList(widget.type);
        for (var item in animelist) {
          Provider.of<AnimeList>(context, listen: false).addAnime(widget.type, Anime(item: item, boolV: false));
        }
        refresh = true;
        }
    } on SocketException catch (_) {
      setState(() {
        connected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimerLoadingScreen(type: widget.type,);
          } else {
            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Container(
                    height: 33,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Theme.of(context).cardColor),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Search(),
                  ),
                ),
                body: connected? orientation(): RefreshIndicator(
                  color: Theme.of(context).highlightColor,
                  child: Stack(
                    children: [ListView(),
                      Center(
                      child: Text(
                                "Check your internet connection and try refreshing", 
                                style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 20),)
                ),
                    ],
                  ), onRefresh: _refresh),
                drawer: DrawerC(
                  bannerImage: Provider.of<User>(context, listen: false).bannerImage, 
                  name: Provider.of<User>(context, listen: false).name, 
                  avatar: Provider.of<User>(context, listen: false).avatar,),
                );
          }
        });
  }

  OrientationBuilder orientation() {
    return OrientationBuilder(builder: (context, orientation) {
                int maxLine;
                maxLine = orientation == Orientation.portrait ? 2 : 1;
                List<Anime>temp = Provider.of<AnimeList>(context).animes[widget.type];
                return SafeArea(
                    child: RefreshIndicator(
                        color: Theme.of(context).highlightColor,
                        onRefresh: _refresh,
                        child: temp.isNotEmpty ? GridView.count(
                          physics: const AlwaysScrollableScrollPhysics(),
                          childAspectRatio:
                              MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 1.4),
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 5,
                          children: temp
                                      .map<Widget>((anime) => CardWidget(
                                            index: temp.indexOf(anime),
                                            type: widget.type,
                                            maxLine: maxLine,
                                          ))
                                      .toList(),
                        ): Center(
                            child: Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              'Add anime to list',
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: 20),),
                          )),));
              });
  }
}
