// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app_296/pages/account_info.dart';
import 'package:mobile_app_296/pages/login_page.dart';

class AccountType extends StatefulWidget {
  const AccountType({super.key});

  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.bold,
                //fontFamily: "Magz",
                color: Colors.black
              ),
            ),

            //SizedBox(height: 50.0),  //Spacing

            Text(
              'Register As A',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                //fontFamily: "Magz",
                color: Colors.black
              ),
            ),
            SizedBox(height: 80.0 ),  //spacing
            
            ElevatedButton( //translator button
              onPressed: () { 
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountInfo()),
                    );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent, // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),

              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Translator',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                'or',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  ),

              ),
            ),
          
            ElevatedButton( //client button
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountInfo()),
                    );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent, // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Client',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black

                    ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => LoginPage())
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold

                    ),
                  ),
                )
              ],
            ),
          /*
          TextButton(
            child: Text(
              'Already have one? Login here',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.black

              ),
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => LoginPage())
              );
            },

          ),*/
          ],
        ),
      ),
    );
  }
}