// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mobile_app_296/pages/account_type.dart';
import 'package:mobile_app_296/pages/login_page.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset('assets/assets/images/ttmainpic.jpeg'),
            Spacer(),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tongue',
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: const Color.fromARGB(255, 141, 161, 177),
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  
                    fontFamily: "Magz",
                    fontWeight: FontWeight.bold, 
                    fontSize: 50, 
                    color: Color.fromARGB(226, 214, 238, 231)
                    
                    )
                  ),
                  Text('Tied',
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: const Color.fromARGB(255, 141, 161, 177),
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  
                    fontFamily: "Magz",
                    fontWeight: FontWeight.bold, 
                    fontSize: 50, 
                    color: Color.fromARGB(226, 214, 238, 231)
                    
                    )
                  ),

                ],
              ),
            ),
            Spacer(),

            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton (
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountType()),
                    );
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
                      'Create An Account',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
              
                        ),
                    ),
                  ),
                  
              ),
            ),
            
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

        ]),
        ),
      ),
  

    );
  }
}