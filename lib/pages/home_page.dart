// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data as User?;
                  if (user == null) {
                    // The user is signed out
                    print("User is signed out");
                    // Schedule navigation after the current frame
                    Future.delayed(Duration.zero, () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    });
                  } else {
                    // The user is signed in
                    print("User is signed in: ${user.email}");
                  }
                }

                return Container(); 
              },
            ),
            Center(child: Text(
              "Signed In!",
              style: TextStyle(
                fontSize: 15
              )
              )),
            ElevatedButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      
                    ),
                    
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
              
                        ),
                    ),
                  ),
            )
            


          ],

        )
      ),
      
      );
  }

  
}