import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';

import 'dart:io';

import '../src/anime.dart';

import '../src/episode_launcher.dart';
import '../src/graphql_requests.dart';

@immutable
class AnimeOnListScreen extends StatefulWidget {
  final int type;
  int index;
  bool inList;
  AnimeOnListScreen({required this.index, required this.type, this.inList = false});
  @override
  _AnimeOnListScreenState createState() => _AnimeOnListScreenState();
}

class _AnimeOnListScreenState extends State<AnimeOnListScreen> {
  String? statusValue;
  final dir = Directory('/storage/emulated/0/Download/');
  
  int episode = 0;
  double score = 0.0;
  Map<String, String> states = {
    'CURRENT': 'Currently watching',
    'PLANNING': 'Plan to watch',
    'PAUSED': 'On hold',
    'DROPPED': 'Droped',
    'COMPLETED': 'Completed',
  };

  @override
  void initState() {
    statusValue = 'Currently watching';
    episode = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.type != 5 && widget.type != 6){
    setState(() {
      statusValue =
          Provider.of<AnimeList>(context).animes[widget.type][widget.index].userStatus;
      episode = Provider.of<AnimeList>(context).animes[widget.type][widget.index].episode;
    });
    }
    else if(Provider.of<AnimeList>(context).animes[widget.type][widget.index].userStatus != null){
      widget.inList = true;
    }
    else {
      widget.inList = false;
    }
    return Scaffold(
        body: ListView(
      children: [
        Stack(
          fit: StackFit.loose,
          children: [
            coverImage(context),
            Container(
              alignment: Alignment.bottomCenter,
              height: 200,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Theme.of(context).hoverColor,
                        Theme.of(context).secondaryHeaderColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 1.0),
                      stops: const [0.0, 1.0])),
              child: Row(children: [
                ///////////////////////Anime Name widget///////////////////////

                animeName(context),

                ///////////////////////Play button ////////////////////////////
              if(widget.type != 5 && widget.type != 6)
                playEpisode(context)
              else
                addToList(context)
              ]),
            ),

            ///////////////////////Back button////////////////////////////

            Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
          ],
        ),

        ///////////////////////Anime status drop down ////////////////////////////
        if(widget.type != 5 && widget.type != 6)
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            updateStatus(context),

            ///////////////////////Progrees drop down ////////////////////////////

            updateProgress(context),

            updateScore(context),
          ],
        )
        ,
        Container(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            'Synopsis:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Theme.of(context).textSelectionTheme.cursorColor),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15, right: 10),
          child: Text(
            Provider.of<AnimeList>(context)
                .animes[widget.type][widget.index]
                .synopsis
                .replaceAll('<br>', ''),
                style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),
          ),
        ),
        Container(
          height: 15,
        ),
        animeInfo(context),
        Container(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            'AlternativeTitles:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textSelectionTheme.cursorColor,),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Text(
              '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].englishName}, ${Provider.of<AnimeList>(context).animes[widget.type][widget.index].romajiName}, ${Provider.of<AnimeList>(context).animes[widget.type][widget.index].nativeName}',
              style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),
            ))
      ],
    ));
  }

  IntrinsicWidth updateScore(BuildContext context) {
    score = Provider.of<AnimeList>(context).animes[widget.type][widget.index].uScore;
    final _cont = TextEditingController(text: '$score');
    return IntrinsicWidth(child: TextFormField(
      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),
      controller: _cont,
      onTap: () => _cont.selection = TextSelection(baseOffset: 0, extentOffset: _cont.value.text.length),
      onFieldSubmitted: (value) async {
        var result = await GqlQuery.saveMediaListEntryScore(
                    Provider.of<AnimeList>(context, listen: false)
                        .animes[widget.type][widget.index]
                        .entryId,
                    double.parse(value));
        setState(() {
                  score = result.data?['SaveMediaListEntry']['score'];
                  Provider.of<AnimeList>(context, listen: false)
                      .updateScore(widget.type, widget.index, score);
                });
      },    
      readOnly: false,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    ));
  }

  Expanded animeName(BuildContext context) {
    return Expanded(
                  child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: '   ' +
                            Provider.of<AnimeList>(context)
                                .animes[widget.type][widget.index]
                                .animeName,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Theme.of(context).textSelectionTheme.cursorColor,
                            fontSize: 15.0),
                      )));
  }

  DropdownButton<String> updateProgress(BuildContext context) {
    return DropdownButton<String>(
              value: 'Episode $episode',
              style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).textSelectionTheme.cursorColor,
                size: 24,
              ),
              elevation: 16,

              //////////////////////Updating prgress/////////////////////////

              onChanged: (String? newValue) async {
                var temp =
                    int.parse(newValue!.replaceAll(RegExp(r'[^0-9]'), ''));
                if (temp > Provider.of<AnimeList>(context, listen: false)
                        .animes[widget.type][widget.index].behindInt + Provider.of<AnimeList>(context, listen: false)
                        .animes[widget.type][widget.index].episode){
                          final snackBar = SnackBar(
                          content: const Text('Episode not aired yet'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else{
                var result = await GqlQuery.saveMediaListEntryProgress(
                    Provider.of<AnimeList>(context, listen: false)
                        .animes[widget.type][widget.index]
                        .entryId,
                    temp);
                setState(() {
                  episode = result.data?['SaveMediaListEntry']['progress'];
                  Provider.of<AnimeList>(context, listen: false)
                      .updateEpisode(widget.type, widget.index, episode);
                });}
              },
              items: List<int>.generate(
                      (Provider.of<AnimeList>(context)
                                  .animes[widget.type][widget.index]
                                  .episodes !=
                              '?')
                          ? (Provider.of<AnimeList>(context)
                                  .animes[widget.type][widget.index]
                                  .episodes +
                              1)
                          : (Provider.of<AnimeList>(context)
                                  .animes[widget.type][widget.index]
                                  .episode + 1 +
                              Provider.of<AnimeList>(context)
                                  .animes[widget.type][widget.index]
                                  .behindInt),
                      (int index) => index)
                  .map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                    value: 'Episode $value', child: Text('Episode $value'));
              }).toList());
  }

  Container playEpisode(BuildContext context) {
    return Container(
                height: 54,
                width: 54,
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 98, 0, 238)),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.play_arrow_sharp,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () async {
                    ///
                    var status = await Permission.storage.status;
                    String fileName = "";
                    var pathToEpisode = "";
                    if (status.isGranted) {
                      await for (FileSystemEntity entity in dir.list(recursive: false, followLinks: false)) {
                      //FileSystemEntityType type = await FileSystemEntity.type(entity.path);
                      fileName = entity.path.split("/").last;
                      if (EpisodeLauncher.launchEpisode(
                        Provider.of<AnimeList>(context, listen: false).animes[widget.type][widget.index].synonyms,
                       fileName,
                        Provider.of<AnimeList>(context, listen: false)
                                .animes[widget.type][widget.index]
                                .episode+1,
                        Provider.of<AnimeList>(context, listen: false)
                                .animes[widget.type][widget.index]
                                .seasonFormat)) {
                        pathToEpisode = entity.path;
                        break;
                      }
                    }
                    if (pathToEpisode != ""){
                      final AndroidIntent intent = AndroidIntent(
                              action: 'action_view',
                              data: Uri.encodeFull(pathToEpisode),
                              type: "video/*");
                      intent.launch();
                      }
                      else {
                        final snackBar = SnackBar(
                          content: const Text('Episode not found'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                            },
                          ),
                        );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    else if (status.isDenied){
                      await [
                        Permission.storage,
                      ].request();
                    }
                  },
                ),
              );
  }

  DropdownButton<String> updateStatus(BuildContext context) {
    return DropdownButton<String>(
              value: states[statusValue],
              style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).textSelectionTheme.cursorColor,
                size: 24,
              ),
              elevation: 16,

              //////////////////////Updating status/////////////////////////

              onChanged: (String? newValue) async {
                var temp =
                    states.keys.firstWhere((k) => states[k] == newValue);
                var result = await GqlQuery.saveMediaListEntryStatus(
                    Provider.of<AnimeList>(context, listen: false)
                        .animes[widget.type][widget.index]
                        .entryId,
                    temp);
                setState(() {
                  statusValue = result.data?['SaveMediaListEntry']['status'];
                  Provider.of<AnimeList>(context, listen: false)
                      .updateStatus(widget.type, widget.index, statusValue);

                  var toChange =  Provider.of<AnimeList>(context, listen: false).animes[widget.type][widget.index];
                  switch (temp) {
                    case 'CURRENT':
                      Provider.of<AnimeList>(context, listen: false).addAnimeN(0, toChange);
                      break;
                    case 'PLANNING':
                      Provider.of<AnimeList>(context, listen: false).addAnimeN(1, toChange);
                      break;
                    case 'PAUSED':
                      Provider.of<AnimeList>(context, listen: false).addAnimeN(2, toChange);
                      break;
                    case 'DROPPED':
                      Provider.of<AnimeList>(context, listen: false).addAnimeN(3, toChange);
                      break;
                    case 'COMPLETED':
                      Provider.of<AnimeList>(context, listen: false).addAnimeN(4, toChange);
                      break;
                  }
                  if(widget.index == 0){
                    Navigator.pop(context);
                  }
                  widget.index--;
                  Provider.of<AnimeList>(context, listen: false).animes[widget.type].removeAt(widget.index+1);
                  
                });
              },
              items:
                  states.values.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList());
  }

  Container addToList(BuildContext context) {
    return Container(
                height: 54,
                width: 54,
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.inList? Theme.of(context).disabledColor : const Color.fromARGB(255, 98, 0, 238)),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    final snackBar = SnackBar(
                          content: const Text('Media already in list'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                            },
                          ),
                        );
                        if(widget.inList){
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        else {
                          await GqlQuery.addMediaListEntry(
                            Provider.of<AnimeList>(context, listen: false)
                                .animes[widget.type][widget.index]
                                .entryId,
                            "PLANNING");
                            Provider.of<AnimeList>(context, listen: false).updateStatus(5, widget.index, "PLANNING");
                            widget.inList = true;
                        }
                  },
                ),
              );
  }

  Container animeInfo(BuildContext context) {
    return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: <TableRow>[
                TableRow(children: [
                  Text(
                    'Type:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textSelectionTheme.cursorColor,),
                  ),
                  const SizedBox(width: 15),
                  Text(
                      '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].seasonFormat}',
                      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor,),)
                ]),
                const TableRow(children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  )
                ]),
                TableRow(children: [
                  Text(
                    'Episodes:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textSelectionTheme.cursorColor),
                  ),
                  const SizedBox(width: 15),
                  Text(
                      '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].episodes}',
                      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),)
                ]),
                const TableRow(children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  )
                ]),
                TableRow(children: [
                  Text(
                    'Status:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textSelectionTheme.cursorColor),
                  ),
                  const SizedBox(width: 15),
                  Text(
                      '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].userStatus}',
                      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),)
                ]),
                const TableRow(children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  )
                ]),
                TableRow(children: [
                  Text(
                    'Season:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Theme.of(context).textSelectionTheme.cursorColor),
                  ),
                  const SizedBox(width: 15),
                  Text(
                      '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].season} ${Provider.of<AnimeList>(context).animes[widget.type][widget.index].seasonYear}',
                      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),)
                ]),
                const TableRow(children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  )
                ]),
                TableRow(children: [
                  Text(
                    'Genres:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textSelectionTheme.cursorColor),
                  ),
                  const SizedBox(width: 15),
                  Text(
                      '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].genres.join(', ')}',
                      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),)
                ]),
                const TableRow(children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  )
                ]),
                TableRow(children: [
                  Text(
                    'Producers:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textSelectionTheme.cursorColor),
                  ),
                  const SizedBox(width: 15),
                  Text(
                      '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].studios.join(', ')}',
                      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),)
                ]),
                TableRow(children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      height: 5,
                      width: 5 * MediaQuery.of(context).size.width / 7)
                ]),
                TableRow(children: [
                  Text(
                    'Score:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textSelectionTheme.cursorColor),
                  ),
                  const SizedBox(width: 15),
                  Text(
                      '${Provider.of<AnimeList>(context).animes[widget.type][widget.index].score}%',
                      style: TextStyle(color: Theme.of(context).textSelectionTheme.cursorColor),)
                ]),
              ]));
  }

  Container coverImage(BuildContext context) {
    return Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Provider.of<AnimeList>(context)
                        .animes[widget.type][widget.index]
                        .coverLink != null? NetworkImage(Provider.of<AnimeList>(context)
                        .animes[widget.type][widget.index]
                        .coverLink) : NetworkImage(Provider.of<AnimeList>(context)
                        .animes[widget.type][widget.index]
                        .imageLink),
                    fit: BoxFit.cover)),
          );
  }
}
