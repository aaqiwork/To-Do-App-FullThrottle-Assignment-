import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/addToDo.dart';
import 'package:todo/screens/authScreen.dart';
import 'package:todo/screens/homeScreen.dart';
import 'package:todo/screens/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
        title: 'Flutter Demo',
        theme: ThemeData(
          //font family of app set here
          fontFamily: 'QuickSand',
          // primary color of app set here
          primaryColor: Color.fromRGBO(250, 250, 250, 1),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting &&
                userSnapshot.connectionState != ConnectionState.done) {
              // loading screen
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              //if user token is present route to HomeScreen
              return HomeScreen();
            }
            //if user token is not present route to AuthScreen
            return AuthScreen();
          },
        ),
        //routes
        routes: {
          AddToDo.routeName: (ctx) => AddToDo(),
        });
  }
}
