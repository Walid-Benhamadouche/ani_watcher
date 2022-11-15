import 'package:flutter/material.dart';
import 'package:project_anime/widgets/search_screen.dart';
import 'package:provider/provider.dart';

import 'widgets/main_screen.dart';
import 'widgets/season_screen.dart';

import 'src/anime.dart';

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AnimeList())
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
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            //visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => MainScreen(
                key: const Key("1"), title: 'Flutter Demo Home Page', screen: 'CURRENT', type: 0,),
            '/plans': (context) => MainScreen(
                key: const Key("1"), title: 'Flutter Demo Home Page', screen: 'PLANNING', type: 1,),
            '/hold': (context) => MainScreen(
                key: const Key("1"), title: 'Flutter Demo Home Page', screen: 'PAUSED', type: 2,),
            '/dropped': (context) => MainScreen(
                key: const Key("1"), title: 'Flutter Demo Home Page', screen: 'DROPPED', type: 3,),
            '/completed': (context) => MainScreen(
                key: const Key("1"), title: 'Flutter Demo Home Page', screen: 'COMPLETED', type: 4,),
            '/seasons': (context) => SeasonScreen(
                key: const Key("1"), title: 'Flutter Demo Home Page'),
            '/search': (context) => SearchScreen(
              key: const Key("1"), title: 'Flutter Demo Home Page')
          },
        ));
  }
}
