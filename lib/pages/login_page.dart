// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/clientUI/cl_navigation.dart';
import 'package:mobile_app_296/pages/app_home.dart';
import 'package:mobile_app_296/pages/create_account.dart';
import 'package:mobile_app_296/translatorUI/t_navigation.dart';
import 'package:mobile_app_296/user%20authentication/user_auth.dart';

import '../user authentication/firestore_data.dart';

//import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final UserAuthentication _auth = UserAuthentication();

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();

class _LoginPageState extends State<LoginPage> {
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 600,
                    width: 340,
                    color: Colors.white,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35
                  
                          ),
                        ),
                        SizedBox(height: 35),

                        //Email text field
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

                          //Password Text Fied
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
                          SizedBox(height: 10),

                          //Sign in button
                          ElevatedButton( 
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent, 
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),

                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(

                                'Sign In',
                                style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),                       
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => CreateAccount()) //rename account info page
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),

                      ],                                            
                      

                    ),

                  ),
                ),
              ],
            ),
          )
        ),
      ),
      

    );
  }

  //add message saying user not found etc.
  void _signIn() async {
    
    String email = _email.text.trim();
    String password = _password.text.trim();


    User? user = await _auth.handleSignIn(context, email, password);
    if(user != null){
      print("User successfully signed in: ${user.email}");
     
      Map<String, dynamic> userData = await getUserData(user.uid);
    
      if(mounted && userData != null && userData.containsKey('accountType')){
        String accountType = userData['accountType'];
        print('User account type is $accountType');
        if(accountType == 'Client'){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => ClientNavigation())
          );
        } else if(accountType == 'Translator'){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => TranslatorNavigation())
          );
        } else{
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => AppHomePage())
          );
          print('User data not available or missing account type');
        }
        
      }

    } else{
      
      print("Unable to sign user in");
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => AppHomePage())
          );


    }

  }
}