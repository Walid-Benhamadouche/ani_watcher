import 'package:flutter/material.dart';

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
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(0, 255, 255, 255),
                                      Color.fromARGB(230, 255, 255, 255)
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(0.0, 1.0),
                                    stops: [0.0, 1.0])),
                            
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                                child: Text(name, style: const TextStyle(fontSize: 23),),
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
                          title: Text('Currently watching', style: TextStyle(color: Colors.grey[700])),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/');
                          },
                        ),
                        ListTile(
                          title: Text('Plan to watch', style: TextStyle(color: Colors.grey[700])),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/plans');
                          },
                        ),
                        ListTile(
                          title: Text('On hold', style: TextStyle(color: Colors.grey[700])),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/hold');
                          },
                        ),
                        ListTile(
                          title: Text('Dropped', style: TextStyle(color: Colors.grey[700])),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/dropped');
                          },
                        ),
                        ListTile(
                          title: Text('Completed', style: TextStyle(color: Colors.grey[700])),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/completed');
                          },
                        ),
                        ListTile(
                          title: Text('Seasons', style: TextStyle(color: Colors.grey[700])),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/seasons');
                          },
                        ),
                        ListTile(
                          title: Text('Search', style: TextStyle(color: Colors.grey[700])),
                          onTap: () async {
                            Navigator.popAndPushNamed(context, '/search');
                          },
                        ),
                ]));
  }
}