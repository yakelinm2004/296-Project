// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/pages/home_page.dart';
import 'package:mobile_app_296/pages/login_page.dart';
import 'package:mobile_app_296/user%20authentication/user_auth.dart';

class AccountInfo extends StatefulWidget {
  
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

final FirebaseAuthentication _auth = FirebaseAuthentication();

//Text field controllers
TextEditingController _email = TextEditingController();
TextEditingController _firstName = TextEditingController();
TextEditingController _lastName = TextEditingController();
TextEditingController _password = TextEditingController();



@override
void dispose(){
  _email.dispose();
  _password.dispose();
}


class _AccountInfoState extends State<AccountInfo> {
//State of radio button
String selectedOption = '';

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

                          RadioListTile(
                            title: Text("Client"),
                            value: "Client", groupValue: selectedOption, onChanged: (value){
                            setState(() {
                              selectedOption = value.toString();
                            });
                          }),
                          
                          SizedBox(height: 30),
                          //Sign Up Button
                          ElevatedButton( //translator button
                            onPressed: _signUp,
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

  void _signUp() async{

    String email = _email.text.trim();
    String password = _password.text.trim();
    String firstName = _firstName.text.trim();
    String lastName = _lastName.text.trim();

    try{

      User? user = await _auth.signUpWitheEmailAndPassword(email, password, context);

    //surround this with try/catch blocks for exception handling
    if(user != null){
      print("User successfully created");

      FirebaseFirestore? info = await _auth.storeUserInformation(email, password, firstName, lastName);
      if(info != null){
        print("User data successfully stored");

        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage())
        );
      } else{
        print("An error occurred storing user data");
      }
      
    } else{
      print("Error creating user");
    }
    } catch(e){
      print("An error ocurred: $e");
    }
    

    
  
}

}


