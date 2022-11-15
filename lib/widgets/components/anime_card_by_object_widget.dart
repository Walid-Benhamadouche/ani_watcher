import 'package:flutter/material.dart';

import '../../src/anime.dart';

class CardWidget extends StatefulWidget {
  final int index;
  CardWidget({required this.anime, required this.maxLine, required this.index});
  final Anime anime;
  final int maxLine;

  @override
  _CardWidget createState() => _CardWidget();
}

class _CardWidget extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 10),
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
                      image: NetworkImage(widget.anime.imageLink),
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
                          text: widget.anime.animeName,
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
                      'EP ${widget.anime.episodes}',
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
                      children: [
                        Text(
                          '${widget.anime.seasonFormat} ${widget.anime.season} ${widget.anime.seasonYear}',
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(225, 255, 255, 255),
                              fontSize: 9.0),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
