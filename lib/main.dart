import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

import 'card.dart';
import 'auth.dart';
import 'authentication_controller.dart';
import 'client.dart';

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

    return /*GraphQLProvider(
        client: graphql.client,
        child: */
        MaterialApp(
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
  String name = '';
  int id = -1;
  String query = '''
                query { # Define which variables will be used in the query (id)
                  Viewer { # Insert our variables into the query arguments (id) (type: ANIME is hard-coded in the query)
                    id
                    name
                  }
                }
                ''';
  @override
  void initState() {
    super.initState();
  }

  Future<void> initApp() async {
    await AuthenticationController.isTokenPresent();
    if (AuthenticationController.isAuthenticated) {
      var accessToken = await AuthenticationController.authenticate();
      //print("auth $accessToken");
      await GQLClient.initClient(accessToken: accessToken);
      final QueryOptions options = QueryOptions(
        document: gql(query),
      );
      final QueryResult result = await GQLClient.client.query(options);
      if (result.hasException) {
        name = result.exception.toString();
      } else {
        name = result.data?['Viewer']['name'];
      }
    } else {
      await GQLClient.initClient();
    }
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
                      children: <Widget>[
                        Container(
                          //color: Colors.red,
                          child: CardWidget(
                            imageLink:
                                "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx131586-k0X2kVpUOkqX.jpg",
                            animeName: "86: Eighty Six Part 2",
                            episode: "Ep 04",
                            timeToNextEpisode: "3d 20h 41m",
                            season: "TV Fall 2021",
                            maxLine: maxLine,
                          ),
                        ),
                        CardWidget(
                          imageLink:
                              "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx127720-ADJgIrUVMdU9.jpg",
                          animeName:
                              "Mushoku Tensei: Isekai Ittara Honki Dasu Part 2gfdgjhfghjfhkjkjhlk",
                          episode: "Ep 04",
                          timeToNextEpisode: "3d 20h 41m",
                          season: "TV Fall 2021",
                          maxLine: maxLine,
                        ),
                        CardWidget(
                          imageLink:
                              "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx3002-RhSiBs8HiP4g.png",
                          animeName: "Gyakkyou Burai Kaiji: Ultimate Survivor",
                          episode: "Ep 25",
                          timeToNextEpisode: "",
                          season: "TV Fall 2007",
                          maxLine: maxLine,
                        ),
                        CardWidget(
                          imageLink:
                              "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx113596-LKA0bYJGjLnB.jpg",
                          animeName: "Josee to Tora to Sakanatachi",
                          episode: "Ep 01",
                          timeToNextEpisode: "3d 20h 41m",
                          season: "Movie Winter 2021",
                          maxLine: maxLine,
                        ),
                        CardWidget(
                          imageLink:
                              "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx20670-3B1bxzAp0AUr.jpg",
                          animeName: "Kuroshitsuji: Book of Murder",
                          episode: "Ep 04",
                          timeToNextEpisode: "",
                          season: "OVA Fall 2014",
                          maxLine: maxLine,
                        ),
                        CardWidget(
                          imageLink:
                              "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx100268-SUZCprpenPzC.png",
                          animeName: "Natsume Yuujinchou: Utsusemi ni Musubu",
                          episode: "Ep 01",
                          timeToNextEpisode: "",
                          season: "Movie Fall 2018",
                          maxLine: maxLine,
                        ),
                      ],
                    ),
                  );
                }),
                drawer: Drawer(
                    child: AuthenticationController.isAuthenticated
                        ? Text("name: $name")
                        : TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () async {
                              var accessToken = await Auth().getAccessToken();
                              await GQLClient.initClient(
                                  accessToken: accessToken);
                              final QueryOptions options = QueryOptions(
                                document: gql(query),
                              );
                              final QueryResult result =
                                  await GQLClient.client.query(options);
                              if (result.hasException) {
                              } else {
                                setState(() {
                                  name = result.data?['Viewer']['name'];
                                });
                              }
                            },
                            child: const Text("Authenticate"),
                          )));
          }
        });
  }
}
