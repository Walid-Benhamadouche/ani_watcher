import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '../src/anime.dart';
import '../src/user_data.dart';
import '../src/graphql_requests.dart';

import 'components/drawer_widget.dart';
import 'components/anime_card_discover_widget.dart';

@immutable
class SearchScreen extends StatefulWidget {
  String search;
  bool focus = true;
  SearchScreen({required Key key, required this.title, this.search = ''}) : super(key: key);

  final String title;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  dynamic queryList;
  List<Anime> animelist = [];
  @override
  void initState() {
    super.initState();
  }

  Future initApp() async {
    QueryResult queryListRes =
        await GqlQuery.searchAnime(widget.search, false);
    if (queryListRes.hasException) {
    } else {
      queryList = queryListRes.data?['Page']['media'] as List<dynamic>;
    }
    Provider.of<AnimeList>(context, listen: false).clearList(6);
    for (var item in queryList) {
      Provider.of<AnimeList>(context, listen: false).addAnime(6, Anime(item: item, boolV: true));
    }
  }

  Future _refresh() async {
    QueryResult queryListRes =
        await GqlQuery.searchAnime(widget.search, true);
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
                      border: Border.all(width: 0.5, color: Theme.of(context).cardColor),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      showCursor: true,
                      controller: TextEditingController()..text = widget.search,
                      autofocus: widget.focus,
                      onSubmitted: (value) {
                        setState(() {
                          widget.search = value;
                          widget.focus = false;
                        });
                      },
                      style: TextStyle(
                        color: Theme.of(context).textSelectionTheme.cursorColor,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                      cursorHeight: 17,
                      cursorWidth: 1,
                      cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search anime',
                        hintStyle: TextStyle(color: Theme.of(context).iconTheme.color),
                        contentPadding: const EdgeInsets.only(left: 10.0),
                        suffixIcon: Icon(
                          Icons.search_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                ),
                body: OrientationBuilder(
                  builder: (context, orientation) {
                    int maxLine;
                    maxLine = 14;
                    List<Anime>temp = Provider.of<AnimeList>(context).animes[6];
                    return SafeArea(
                        child: RefreshIndicator(
                          color: Theme.of(context).highlightColor,
                            onRefresh: _refresh,
                            child: temp.isNotEmpty ? Column(children: [
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
                                children: temp.map<Widget>((anime) => AnimeCardDiscover(
                                  index: temp.indexOf(anime),
                                  anime: anime,
                                  maxLine: maxLine,
                                  type: 6,
                                ))
                            .toList(),
                            ),)
                            ]) : Center(
                              child: Container(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "Search for an anime", 
                                style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 20),),
                            )),
                            ));
                  },
                ),
                drawer: DrawerC(
                  bannerImage: Provider.of<User>(context, listen: false).bannerImage, 
                  name: Provider.of<User>(context, listen: false).name, 
                  avatar: Provider.of<User>(context, listen: false).avatar,),
                );
          }
        });
  }
}
