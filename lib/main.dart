import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

import 'auth.dart';
import 'authentication_controller.dart';
import 'client.dart';
import 'anime.dart';
import 'graphql_requests.dart';

import 'card.dart';
import 'profile_card.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const MaterialColor white = MaterialColor(
      0xFFFFFFFF,
      <int, Color>{
        50: Color(0xFFFFFFFF),
        100: Color(0xFFFFFFFF),
        200: Color(0xFFFFFFFF),
        300: Color(0xFFFFFFFF),
        400: Color(0xFFFFFFFF),
        500: Color(0xFFFFFFFF),
        600: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      },
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: white,
        scaffoldBackgroundColor: white,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(key: const Key("1"), title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int id = -1;
  String name = '';
  String avatar = '';
  String bannerImage = '';
  var animelist = null;
  //Map<dynamic, dynamic> animlist = Map<dynamic, dynamic>();
  @override
  void initState() {
    super.initState();
  }

  Future<void> initApp() async {
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

      QueryResult animeListRes = await GqlQuery.getAnimeList(id);
      if (animeListRes.hasException) {
      } else {
        animelist = animeListRes.data?['MediaListCollection']['lists'][0]
            ['entries'] as List<dynamic>;
      }
    } else {
      await GQLClient.initClient();
    }
  }

  List<Widget> animeListCreator(maxLine) {
    List<Anime> animes = [];
    for (var item in animelist) {
      animes.add(Anime(item: item));
    }
    return animes
        .map<Widget>((anime) => CardWidget(
              imageLink: anime.imageLink,
              animeName: anime.animeName,
              episode: 'EP ${anime.episode}${anime.behind}/${anime.episodes}',
              timeToNextEpisode: anime.timeToNextEpisodeString,
              season:
                  '${anime.seasonFormat} ${anime.season} ${anime.seasonYear}',
              maxLine: maxLine,
            ))
        .toList();
  }

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
                    child: const TextField(
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search anime',
                        contentPadding: EdgeInsets.only(left: 10.0),
                        suffixIcon: Icon(
                          Icons.search_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                body: OrientationBuilder(builder: (context, orientation) {
                  int maxLine;
                  maxLine = orientation == Orientation.portrait ? 2 : 1;
                  return SafeArea(
                      child: GridView.count(
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.4),
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 5,
                    children: animeListCreator(maxLine),
                  ));
                }),
                drawer: Drawer(
                    child: ListView(children: [
                  AuthenticationController.isAuthenticated
                      ? ProfileCard(
                          avatar: avatar,
                          bannerImage: bannerImage,
                          name: name,
                        )
                      : TextButton(
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
                        )
                ])));
          }
        });
  }
}
