import 'package:flutter/material.dart';
import 'package:project_anime/src/user_data.dart';
import 'package:provider/provider.dart';

import '../src/authentication_controller.dart';
import '../src/client.dart';

import 'components/splash_screen_widget.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({ Key? key }) : super(key: key);

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  Future initApp() async {
    await AuthenticationController.isTokenPresent();
    if (AuthenticationController.isAuthenticated) {
      var accessToken = await AuthenticationController.authenticate();
      await GQLClient.initClient(accessToken: accessToken);
      Provider.of<User>(context, listen: false).initUser();
      Navigator.popAndPushNamed(context, '/current');
    } else {
      //await GQLClient.initClient();
    }
  }

  Future logIn() async {
    var accessToken = await AuthenticationController.authenticate();
      var cond = await GQLClient.initClient(
          accessToken: accessToken);
      if(cond)
        {
          Provider.of<User>(context, listen: false).initUser();
          Navigator.popAndPushNamed(context, '/current');
        }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initApp(),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || 
              AuthenticationController.isAuthenticated) {
            return SplashScreen();
          } else{
             return Scaffold(body: 
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("Autheticate using Anilist account", style: TextStyle(fontSize: 18,color: Theme.of(context).textSelectionTheme.cursorColor),),
                ),
                Center(child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () async {
                            await logIn();
                          },
                          child: const Text("Log In"),
                        ),),
              ],));
          } 
          });
  }
}