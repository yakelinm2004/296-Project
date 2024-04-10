import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app_296/clientUI/cl_navigation.dart';
import 'package:mobile_app_296/pages/login_page.dart';
import 'package:mobile_app_296/clientUI/cl_profile_page.dart';

import 'pages/app_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tongue Tied',
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data as User?;
          if (user == null) {
            // The user is signed out
            print("User is signed out");
            return AppHomePage();
          } else {
            // The user is signed in
            print("User is signed in: ${user.email}");
            return ClientNavigation();  //return userAuth page that will determine if client or user
          }
        }

        // By default, show a loading spinner
        return const CircularProgressIndicator();
      },
    );
  }
}
