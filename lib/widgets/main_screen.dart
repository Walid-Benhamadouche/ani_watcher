import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:project_anime/widgets/components/drawer_widget.dart';
import 'package:provider/provider.dart';

import '../src/authentication_controller.dart';
import '../src/client.dart';
import '../src/anime.dart';
import '../src/graphql_requests.dart';

import 'components/anime_card_widget.dart';
import 'components/search_widget.dart';

class MainScreen extends StatefulWidget {
  final String title;
  final String screen;
  final int type;
  MainScreen({required Key key, required this.title, required this.screen, required this.type}) : super(key: key);


  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int id = -1;
  String name = '';
  String avatar = '';
  String bannerImage = '';
  dynamic animelist;
  bool refresh = false;
  @override
  void initState() {
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
      if(!refresh){
      QueryResult animeListRes = await GqlQuery.getAnimeList(id, true, widget.screen);
      if (animeListRes.hasException) {
      } else {
        animelist = animeListRes.data?['MediaListCollection']['lists'][4 - widget.type]
            ['entries'] as List<dynamic>;
      }
      Provider.of<AnimeList>(context, listen: false).clearList(widget.type);
    for (var item in animelist) {
      Provider.of<AnimeList>(context, listen: false).addAnime(widget.type, Anime(item: item, boolV: false));
    }
    }
    refresh = false;
    } else {
      await GQLClient.initClient();
    }
    //_refresh();
    
  }

  Future _refresh() async {
    QueryResult animeListRes = await GqlQuery.getAnimeList(id, true, widget.screen);
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
                body: OrientationBuilder(builder: (context, orientation) {
                  int maxLine;
                  maxLine = orientation == Orientation.portrait ? 2 : 1;
                  List<List<Anime>>temp = Provider.of<AnimeList>(context).animes;
                  return SafeArea(
                      child: RefreshIndicator(
                          color: Colors.blue,
                          onRefresh: _refresh,
                          child: temp[widget.type].isNotEmpty ? GridView.count(
                            physics: const AlwaysScrollableScrollPhysics(),
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.4),
                            crossAxisCount: 2,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 5,
                            children: temp[widget.type]
                                        .map<Widget>((anime) => CardWidget(
                                              index: temp[widget.type].indexOf(anime),
                                              type: widget.type,
                                              maxLine: maxLine,
                                            ))
                                        .toList(),
                          ): Center(
                              child: Container(
                              padding: const EdgeInsets.all(0.0),
                              child: const Text(
                                "Add anime to list", 
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20),),
                            )),));
                }),
                drawer: DrawerC(bannerImage: bannerImage, name: name, avatar: avatar,),
                /*drawer: Drawer(
                    child: ListView(children: [
                        !AuthenticationController.isAuthenticated
                      ? const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text('Drawer Header'),
                        )/*ProfileCard(
                          avatar: avatar,
                          bannerImage: bannerImage,
                          name: name,
                        )*/
                      :  
                      TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () async {
                            var accessToken = await Auth().getAccessToken();
                            await GQLClient.initClient(
                                accessToken: accessToken);

                            final QueryResult result =
                                await GqlQuery.getViewer();
                            if (result.hasException) {
                            } else {
                              setState(() {
                                name = result.data?['Viewer']['name'];
                              });
                            }
                          },
                          child: const Text("Authenticate"),
                        ),*/

                        
                );
          }
        });
  }
}
