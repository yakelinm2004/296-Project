// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/pages/home_page.dart';
import 'package:mobile_app_296/pages/login_page.dart';
import 'package:mobile_app_296/user%20authentication/user_auth.dart';

import '../clientUI/cl_navigation.dart';
import '../translatorUI/t_navigation.dart';
import '../user authentication/firestore_data.dart';

class CreateAccount extends StatefulWidget {
  
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

final UserAuthentication _auth = UserAuthentication();

//Text field controllers
TextEditingController _email = TextEditingController();
TextEditingController _firstName = TextEditingController();
TextEditingController _lastName = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _language = TextEditingController();
//TextEditingController _accountType = TextEditingController();




@override
void dispose(){
  _email.dispose();
  _password.dispose();
}


class _CreateAccountState extends State<CreateAccount> {
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
                    height: 750,
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
                          SizedBox(height: 10,),
                          Text('Enter the language you are familiar with'),
                          SizedBox(height: 10,),

                          //Language text box
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _language,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  hintText: 'Language'
                                ),
                              ),
                            ),
                          ),

                          RadioListTile(
                            title: Text("Client"),
                            value: "Client", groupValue: selectedOption, onChanged: (value){
                            setState(() {
                              selectedOption = value.toString();
                              buttonSelection();
                            });
                          }),
                          

                          RadioListTile(
                            title: Text("Translator"),
                            value: "Translator", groupValue: selectedOption, onChanged: (value){
                            setState(() {
                              selectedOption = value.toString();
                              buttonSelection();
                            });
                          }), 
                          
                          
                          SizedBox(height: 20),
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

                          SizedBox(height: 15),
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
    String accountType = selectedOption;
    String language = _language.text.trim();

  print('Email: $email');
  print('Password: $password');
  print('First Name: $firstName');
  print('Last Name: $lastName');
  print('Account Type: $accountType');



    try{
      print('Starting user sign-up...');
      User? user = await _auth.signUpWitheEmailAndPassword(email, password, context);

      if(user != null && mounted){
        print("User successfully created: ${user.email}");

        bool userInfo = await _auth.storeUserInformation(email, password, firstName, lastName, accountType, language);
        if(userInfo){
          print("User data successfully stored");

          if(accountType == 'Client'){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => ClientNavigation())
              );
          } else if(accountType == 'Translator'){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => TranslatorNavigation())
              );
          } else{
            print("User data not available or missing account type");
          }
        } else{
          print("An error occurred storing user data");
        }

      

      } else{
        print('Error creating user');
      }
    
/*
      FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async { 
          print('auth state changed: $user');

          if(user != null){
            String userID = user.uid;
            print("user id: $userID");
          
            print('Starting data storage...');
            FirebaseFirestore? userInfo = 
              await _auth.storeUserInformation(email, password, firstName, lastName, accountType);

            if(userInfo != null && mounted){
              print("User data successfully stored");
              
              Map<String, dynamic> userData = await getUserData(userID);
              if(userData.containsKey('accountType')){
                String accountType = userData['accountType'];
                print('User account type is $accountType');

                if(accountType == 'Client'){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ClientNavigation())
                  );
                } 
                else if(accountType == 'Translator'){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => TranslatorNavigation())
                    );
                } else{
                  print('User data not available or missing account type');
                }
              }

            } else{
              print("An error occurred storing user data");
            }          



          } 
        });
*/
    //surround this with try/catch blocks for exception handling
   // if(user != null){
      //print("User successfully created");
  

      
    //} else{
    //  print("Error creating user");
    //}
    } catch(e){
      print("An error ocurred: $e");
    }
    

    
  
}

//Prints what button was selected to console
void buttonSelection() async{
  if(selectedOption == "Client"){
    print("Client button selected");
  } else if(selectedOption == "Translator"){
    print("Translator button selected");
  }
}

}


