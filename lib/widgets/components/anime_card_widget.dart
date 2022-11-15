import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src/anime.dart';

import '../anime_onlist_screen.dart';

class CardWidget extends StatefulWidget {
  CardWidget({required this.index, required this.maxLine, required this.type});
  int index;
  int type;
  int maxLine;

  @override
  _CardWidget createState() => _CardWidget();
}

class _CardWidget extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    int len = Provider.of<AnimeList>(context, listen: false).animes[widget.type].length;
    if(widget.index < len) {
      return Card(
      margin: const EdgeInsets.only(left: 10, right: 10),
      semanticContainer: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              //height: 200,
              //width: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(Provider.of<AnimeList>(context)
                          .animes[widget.type][widget.index]
                          .imageLink),
                      fit: BoxFit.cover)),
              child: null),
          Container(
              //width: 140,
              //height: 80,
              height: MediaQuery.of(context).size.height / 8,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: const Color.fromARGB(178, 7, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    //height: 32,
                    //width: 135,
                    margin: const EdgeInsets.only(left: 2),
                    alignment: Alignment.topCenter,
                    child: RichText(
                        maxLines: widget.maxLine,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: Provider.of<AnimeList>(context)
                              .animes[widget.type][widget.index]
                              .animeName,
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(225, 255, 255, 255),
                              fontSize: 15.0),
                        )),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'EP ${Provider.of<AnimeList>(context).animes[widget.type][widget.index].episode}${Provider.of<AnimeList>(context).animes[widget.type][widget.index].behind}/${Provider.of<AnimeList>(context).animes[widget.type][widget.index].episodes}  ${Provider.of<AnimeList>(context).animes[widget.type][widget.index].timeToNextEpisodeString}',
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Color.fromARGB(225, 255, 255, 255),
                          fontSize: 12.0),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(left: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].seasonFormat} ${Provider.of<AnimeList>(context).animes[widget.type][widget.index].season} ${Provider.of<AnimeList>(context).animes[widget.type][widget.index].seasonYear}',
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(225, 255, 255, 255),
                              fontSize: 9.0),
                        ),
                        if(Provider.of<AnimeList>(context).animes[widget.type][widget.index].status == 'RELEASING')
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 4, 4),
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              
                              color: Colors.green,
                              shape: BoxShape.circle,
                                ))
                        else if(Provider.of<AnimeList>(context).animes[widget.type][widget.index].status == 'NOT_YET_RELEASED')
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 4, 4),
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              
                              color: Colors.red,
                              shape: BoxShape.circle,
                                ))
                        else
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 4, 4),
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              
                              color: Colors.blue,
                              shape: BoxShape.circle,
                                )),
                      ],
                    ),
                  )
                ],
              )),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.black.withAlpha(20),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AnimeOnListScreen(index: widget.index, type: widget.type);
                }));
              },
            ),
          )
        ],
      ),
    );
    }else {return Container();}
  }
}
