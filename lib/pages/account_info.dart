// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

final _email = TextEditingController();
final _firstName = TextEditingController();
final _lastName = TextEditingController();
final _password = TextEditingController();

Future createAccount() async{
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _email.text.trim(), 
    password: _password.text.trim()
  );

  userInformation(
    _firstName.text.trim(), 
    _lastName.text.trim(), 
    _email.text.trim()
  );
}

Future userInformation(String firstName, String lastName, String email) async{
  await FirebaseFirestore.instance.collection('users').add({
    'first name': firstName,
    'last name': lastName,
    'email': email
});
}

@override
void dispose(){
  _email.dispose();
  _password.dispose();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                   // fontFamily: 'tbd'
                  ),
                ),
                SizedBox(height: 30), //spacing
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 600,
                    width: 340,
                    color: Colors.white,
                    
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          
                          //First Name Text Box
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _firstName,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  hintText: 'First Name'
                                ),
                              ),
                            ),
                          ),
                      
                          //Last Name Text Book
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _lastName,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  hintText: 'Last Name'
                                ),
                              ),
                            ),
                          ),
                      
                          //Email Text Box
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _email,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  hintText: 'Email'
                                ),
                              ),
                            ),
                          ),
                      
                          //Password Text Box
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  hintText: 'Password'
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 30),
                          //Sign Up Button
                          ElevatedButton( //translator button
                            onPressed: createAccount,
                            style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent, 
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),

                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(

                                'Sign Up',
                                style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                                ),
                              ),
                            ),
                          ),
                          
                      
            
                        ],
                      ),
                    ),
                        
                  
                  ),
                ),
              ],
            ),
          ),
        
        ),
      ),



    );
  }
}
Widget accountInfo() => Container(
  child: Padding(
    padding: EdgeInsets.all(10),


  )

);

