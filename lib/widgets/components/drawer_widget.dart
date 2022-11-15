import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src/authentication_controller.dart';
import '../../src/user_data.dart';

import '../../src/client.dart';

class DrawerC extends StatelessWidget {
  String bannerImage;
  String name;
  String avatar;
  DrawerC({required this.bannerImage, required this.name, required this.avatar});
  @override
  Widget build(BuildContext context) {
    return Drawer(
                    child: ListView(children: [
                      Stack(
                        fit: StackFit.loose,
                        children: [
                          SizedBox(
                            height: 200,
                            child: DrawerHeader(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(bannerImage),
                                    fit: BoxFit.cover)
                              ),
                              child: Container(),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            height: 192,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).hoverColor,
                                      Theme.of(context).secondaryHeaderColor
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(0.0, 1.0),
                                    stops: const [0.0, 1.0])),
                            
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                                child: Text(name, style: TextStyle(fontSize: 23, color: Theme.of(context).textSelectionTheme.cursorColor),),
                                ),          
                          ),
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  //color: Colors.amber,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(avatar), fit: BoxFit.cover)
                                    ),
                                  ),
                          )
                        ],
                      ),
                        ListTile(
                          leading: Icon(Icons.feed_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('Currently watching', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/current');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.bookmark_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('Plan to watch', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/plans');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.pause_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('On hold', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/hold');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.close_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('Dropped', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/dropped');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.done_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('Completed', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/completed');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.calendar_today_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('Seasons', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/seasons');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.search_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('Search', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/search');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.download_sharp, color: Theme.of(context).iconTheme.color,),
                          title: Text('Download', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/nyaa');
                          },
                        ),ListTile(
                          leading: Icon(Icons.logout, color: Theme.of(context).iconTheme.color,),
                          title: Text('Log out', style: TextStyle(color: Theme.of(context).indicatorColor)),
                          onTap: () async {
                            AuthenticationController.logOut();
                            GQLClient.clientS(null);
                            //await GQLClient.initClient();
                            Provider.of<User>(context, listen: false).updateId(-1);
                            Provider.of<User>(context, listen: false).updateName("");
                            Provider.of<User>(context, listen: false).updateAvatar("");
                            Provider.of<User>(context, listen: false).updateBannerImage("");
                            Navigator.popUntil(context, (route) => route.isFirst);
                            Navigator.popAndPushNamed(context, '/login');
                          },
                        ),
                ]));
  }
}