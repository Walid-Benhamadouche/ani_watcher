import 'package:flutter/material.dart';
import 'package:project_anime/widgets/search_screen.dart';
import 'package:provider/provider.dart';

import 'widgets/main_screen.dart';
import 'widgets/authentication_screen.dart';
import 'widgets/season_screen.dart';
import 'widgets/nyaa_si_screen.dart';

import 'src/anime.dart';
import 'src/user_data.dart';

void main() async {
  runApp(const MyApp(key: Key("1")));
}
@immutable
class MyApp extends StatelessWidget {
  const MyApp({required Key key,}) : super(key: key);
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
    const MaterialColor blackD = MaterialColor(
      0xFF212121,
      <int, Color>{
        50: Color(0xFF44475a),
        100: Color(0xFF44475a),
        200: Color(0xFF44475a),
        300: Color(0xFF44475a),
        400: Color(0xFF44475a),
        500: Color(0xFF44475a),
        600: Color(0xFF44475a),
        700: Color(0xFF282a36),
        800: Color(0xFF282a36),
        900: Color(0xFF282a36),
      },
    );


    return MultiProvider( 
        providers: [
          ChangeNotifierProvider(create: (context) => AnimeList()),
          ChangeNotifierProvider(create: (context) => User())
        ],
        child: MaterialApp(
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
                  shadowColor: white,
                  disabledColor: Colors.grey,
                  highlightColor: Colors.blue,
                  hoverColor: const Color.fromARGB(0, 255, 255, 255),
                  secondaryHeaderColor: const Color.fromARGB(230, 255, 255, 255),
                  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
                  iconTheme: const IconThemeData(color: Colors.grey),
                  cardColor: Colors.grey[300]!,
                  indicatorColor: Colors.grey[700],
                  canvasColor: white
                  // This makes the visual density adapt to the platform that you run
                  // the app on. For desktop platforms, the controls will be smaller and
                  // closer together (more dense) than on mobile platforms.
                  //visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                
                darkTheme: ThemeData(
                  // This is the theme of your application.
                  //
                  // Try running your application with "flutter run". You'll see the
                  // application has a blue toolbar. Then, without quitting the app, try
                  // changing the primarySwatch below to Colors.green and then invoke
                  // "hot reload" (press "r" in the console where you ran "flutter run",
                  // or simply save your changes to "hot reload" in a Flutter IDE).
                  // Notice that the counter didn't reset back to zero; the application
                  // is not restarted.
                  primarySwatch: blackD,
                  scaffoldBackgroundColor: blackD,
                  shadowColor: Colors.grey[700],
                  disabledColor: Colors.grey[400],
                  highlightColor: Colors.blue,
                  hoverColor: const Color.fromARGB(0, 0, 0, 0),
                  secondaryHeaderColor: const Color.fromARGB(230, 0, 0, 0),
                  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white70),
                  iconTheme: IconThemeData(color: Colors.grey[400]),
                  cardColor: Colors.grey[800],
                  indicatorColor: Colors.grey[400],
                  canvasColor: blackD
                  // This makes the visual density adapt to the platform that you run
                  // the app on. For desktop platforms, the controls will be smaller and
                  // closer together (more dense) than on mobile platforms.
                  //visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                //darkTheme: ThemeData.dark(),
                initialRoute: '/login',
                routes: {
                  '/login': (context) => AuthenticateScreen(
                    key: key,),
                  '/current': (context) => MainScreen(
                    title: 'Currently watching', screen: 'CURRENT', type: 0,),
                  '/plans': (context) => MainScreen(
                    title: 'Planning to watch', screen: 'PLANNING', type: 1,),
                  '/hold': (context) => MainScreen(
                    title: 'On hold', screen: 'PAUSED', type: 2,),
                  '/dropped': (context) => MainScreen(
                    title: 'Dropped', screen: 'DROPPED', type: 3,),
                  '/completed': (context) => MainScreen( 
                    title: 'Completed', screen: 'COMPLETED', type: 4,),
                  '/seasons': (context) => const SeasonScreen(
                      key: Key("6"), title: 'Season'),
                  '/search': (context) => SearchScreen(
                    key: const Key("7"), title: 'Search'),
                  '/nyaa': (context) => NyaaSiScreen(
                    title: 'Nyaa')
                }
        )
        );  
  }
}
