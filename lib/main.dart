import 'package:authentification/models/user_model.dart';
import 'package:authentification/screens/home_screen.dart';
import 'package:authentification/screens/sign_screen.dart';
import 'package:authentification/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // provider package making inherited widgets easies
    // here accessing the whole auth class to access its elements
    return Provider<Auth>(
      create: (context) => Auth(),
      child: MaterialApp(
        // make sure the set your theme 
        theme: ThemeData.dark(),
        // page before sign in and home
        home: LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // accessing the auth class from provider
    final auth = Provider.of<Auth>(context, listen: false); // must specify type // without listen doesnt work in this version of provider
    // stram builder that wiill return home or signScreen depending if user is null meaning firebaseUser
    return StreamBuilder<User>(
      // stream created in auth class that listens for user state signed or not (null)
      stream: auth.userAuthState,
      builder: (context, snapshot){
        // checking if connection state is active and data of user at specific moment is valid
        if (snapshot.connectionState == ConnectionState.active) {
          // if that data is not null that we return home , else sign in
          User user = snapshot.data; // can return null value
          return (user == null) ? SignScreen.create(context) 
          : HomeScreen();
        }else {
          // if no connection a loadingindicatior will be shown
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),)
          );
        }
      });
 
  }
}
