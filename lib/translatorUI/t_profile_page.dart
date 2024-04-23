import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/models/usermodel.dart';

import '../pages/login_page.dart';

class TranslatorProfilePage extends StatefulWidget {
  const TranslatorProfilePage({super.key});

  @override
  State<TranslatorProfilePage> createState() => _TranslatorProfilePageState();
}

class _TranslatorProfilePageState extends State<TranslatorProfilePage> {
  String? myEmail;
  String? myFirstName;
  String? myLastName;
  UserModel? user;


  @override
  void initState() {
    super.initState();
    _getUserInformation();
  }

  Future _getUserInformation() async{
  await FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser!.uid)
  .get()
  .then((snapshot) async{

    if(snapshot.exists){
      setState(() {
        myEmail = snapshot.data()!['email'];
        print('Email: $myEmail');
        myFirstName = snapshot.data()!['first name'];
        print('First name: $myFirstName');
        myLastName = snapshot.data()!['last name'];
        print('Last name: $myLastName');
        
      });
    } else{
      print('Document does not exist');
    }
  }).catchError((error){
    print('Error retrieving user info: $error');
  });
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 207, 216),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 65.0, 8.0, 15.0),
              child: Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1)
                      )
                    ],
                    shape: BoxShape.circle
                  ),
                ),
              ),
            ),

            //User name and role
            Column(
              children: [
                Text(
                  '$myFirstName $myLastName',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  ),
                ),

                Text(
                  'Translator',
                  style: TextStyle(
                    color: Colors.black.withOpacity(1.0),
                    fontWeight: FontWeight.w200,
                    fontSize: 15.0,
                                
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black12,
            ),
            //user email
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10.0),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
              
              
                    ),
                  ),
                ],
              ),
              
            ),
            const Divider(
              color: Colors.black12,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 10.0),
                  Text(
                    'Languages',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
              
              
                    ),
                  ),
                ],
              ),
              
            ),
            const Divider(
              color: Colors.black12,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.payment),
                  SizedBox(width: 10.0),
                  Text(
                    'Payment Information',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
              
              
                    ),
                  ),
                ],
              ),
              
            ),

            const Divider(
              color: Colors.black12,
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  print('sign out button tapped');
                  FirebaseAuth.instance.signOut();
                  print('User is signed out');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage())
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10.0),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                
                
                      ),
                    ),
                  ],
                ),
              ),
              
            ),
            const Divider(
              color: Colors.black12,
            ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.delete_forever),
                  SizedBox(width: 10.0),
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
              
              
                    ),
                  ),
                ],
              ),
              
            ),
          ],
          
        )

      ),

    );
  }
}
