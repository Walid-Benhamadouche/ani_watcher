import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imageLink;
  final String animeName;
  final String episode;
  final String timeToNextEpisode;
  final String season;
  final int maxLine;
  const CardWidget(
      {required this.imageLink,
      required this.animeName,
      required this.episode,
      required this.timeToNextEpisode,
      required this.season,
      required this.maxLine});
  @override
  Widget build(BuildContext context) {
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
                      image: NetworkImage(imageLink), fit: BoxFit.cover)),
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
                        maxLines: maxLine,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: animeName,
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
                      episode + "    " + timeToNextEpisode,
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
                          season,
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
          Container(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.black.withAlpha(20),
              onTap: () {},
            ),
          ))
        ],
      ),
    );
  }
}
