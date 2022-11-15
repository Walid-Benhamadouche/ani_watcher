import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:provider/provider.dart';

import '../src/user_data.dart';

import 'components/drawer_widget.dart';

@immutable
class NyaaSiScreen extends StatefulWidget {
  String search = '';
  NyaaSiScreen({required this.title});

  final String title;

  @override
  _NyaaSiScreenState createState() => _NyaaSiScreenState();
}

class _NyaaSiScreenState extends State<NyaaSiScreen> {
  List<List<String>> searchResults = [];
  @override
  void initState() {
    searchResults = [];
    super.initState();
  }

  Future<RssFeed> getNyaaFeed(String toSearch) async{
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse("https://nyaa.si/?page=rss&q="+toSearch+"&c=0_0&f=0"));
      return RssFeed.parse(response.body);
    } 
    catch (e) {
      print(e);
    }
    return RssFeed.parse("empty");
  }

  Future _refresh() async {
  }

  @override
  Widget build(BuildContext context) {
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
                      onSubmitted: (value) {
                          setState(() {
                            searchResults.clear();
                          });
                        getNyaaFeed(value).then((feed) {
                          for(int i = 0; i< feed.items!.length; i++){
                            setState(() {
                              if(feed.items![i].category.toString() == "Anime - English-translated"){
                                //Parser field = Parser.fromnyaa(name: feed.items![i].title.toString());
                                searchResults.add(
                                  [feed.items![i].title.toString(),
                                  feed.items![i].link.toString(),
                                  feed.items![i].seeders.toString(),
                                  feed.items![i].leechers.toString(),
                                  feed.items![i].size.toString(),
                                  ],
                                  );
                                }
                            });
                          }
                            
                        });
                        setState(() {
                          widget.search = value;
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
                        hintText: 'Search for torrents',
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
                    return SafeArea(
                        child: RefreshIndicator(
                          color: Theme.of(context).highlightColor,
                            onRefresh: _refresh,
                            child: searchResults.isNotEmpty ? Column(children: [
                              Flexible(child: 
                               ListView.builder(
                                 itemCount: searchResults.length,
                                 itemBuilder: (context, index) {
                                   return ListTile(
                                     tileColor: index%2 == 0? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                                     title: Text(searchResults[index][0].toString(), style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),),
                                     subtitle: Text(
                                       "Seeds: "+searchResults[index][2].toString()+" Leeches: "+searchResults[index][3].toString()+" Size: "+searchResults[index][4].toString()
                                     , style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),),
                                     onTap: () {
                                       if (searchResults[index][1].toString() != ''){
                                          final AndroidIntent intent = AndroidIntent(
                                                  action: 'action_view',
                                                  data: Uri.encodeFull(searchResults[index][1].toString()),
                                                  type: ".torrent");
                                          intent.launch();
                                          }
                                     },
                                   );
                                 }),)
                            ]) : Center(
                              child: Container(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "No results", 
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
}
