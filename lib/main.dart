import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app_296/clientUI/cl_navigation.dart';
import 'package:mobile_app_296/pages/login_page.dart';

import 'package:mobile_app_296/translatorUI/t_navigation.dart';

import 'user authentication/firestore_data.dart';

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
            // If no user is signed in, navigate to the login page
            return LoginPage();
          } else {
            // If user is signed in, determine their account type and navigate to appropriate UI components
            return FutureBuilder(
              future: getUserData(user.uid),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> userDataSnapshot) {
                if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  Map<String, dynamic>? userData = userDataSnapshot.data;
                  if (userData != null && userData.containsKey('accountType')) {
                    String accountType = userData['accountType'];
                    if (accountType == 'Client') {
                      return ClientNavigation();
                    } else if (accountType == 'Translator') {
                      return TranslatorNavigation();
                    } else {
                      print('Unknown account type: $accountType');
                      return Container();
                    }
                  } else {
                    print('User data not available or missing account type');
                    return LoginPage();
                  }
                }
              },
            );
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}