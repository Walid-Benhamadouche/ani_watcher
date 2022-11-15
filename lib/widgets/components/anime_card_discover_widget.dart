import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../src/anime.dart';
import '../anime_onlist_screen.dart';

import 'anime_card_by_object_widget.dart';

class AnimeCardDiscover extends StatelessWidget {
  int maxLine;
  int index;
  Anime anime;
  int type;
  bool inList = false;
  AnimeCardDiscover({required this.maxLine, required this.anime, required this.index, required this.type});
  @override
  Widget build(BuildContext context) {
    //return CardWidget(anime: anime, maxLine: 1);
    return Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomCenter,
        children: [
    Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            //height: 450,
            //width: 190,
            flex: 50,
            child: CardWidget(anime: anime, maxLine: 1, index: index,),
          ),
          Expanded(
            //alignment: Alignment.topLeft,
            //color: const Color.fromARGB(255, 233, 50, 50),
            //width: 150,
            flex: 50,
            child: Column(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('Synopsis: ', 
                style: TextStyle(fontWeight: FontWeight.bold, 
                fontSize: 16.0, 
                height: 1.2,
                color: Theme.of(context).textSelectionTheme.cursorColor), 
                overflow: TextOverflow.ellipsis,),
              ),
              Expanded(child: Text((anime.synopsis ?? '').replaceAll(RegExp(
                    r"<[^>]*>",
                    multiLine: true,
                    caseSensitive: true
                    ), ''), style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),),),
              /*RichText(
                maxLines: maxLine,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: (anime.synopsis ?? '').replaceAll(RegExp(
                    r"<[^>]*>",
                    multiLine: true,
                    caseSensitive: true
                    ), ''), //beware of null synopsis
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      color: Color.fromARGB(225, 0, 0, 0),
                      fontSize: 14.0,
                      height: 1.2),
                )),*/
            ],)),
        ],
      ),
    ),
    Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.black.withAlpha(20),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AnimeOnListScreen(index: index, type: type);
                }));
              },
            ),
          )
    ]);
  }
}
