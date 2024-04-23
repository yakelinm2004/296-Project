import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/clientUI/cl_navigation.dart';
import 'package:mobile_app_296/clientUI/cl_profile_page.dart';

import '../user authentication/firestore_data.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
 
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot<Map<String, dynamic>>? userDoc;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _languageController;

  @override
  void initState() {
    
    super.initState();
    
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _languageController = TextEditingController();
    getCurrentUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  void getCurrentUserData() async{
   userDoc = await FirebaseFirestore.instance
   .collection('users')
   .doc(_currentUser!.uid)
   .get();

   if(userDoc != null){
    _firstNameController.text = userDoc!['first name'] ?? '';
    _lastNameController.text = userDoc!['last name'] ?? '';
    _emailController.text = userDoc!['email'] ?? '';
    _languageController.text = userDoc!['language'] ?? '';
   }
     
  


  }

  void updateAccountInfo() async {
    try{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(_currentUser!.uid)
    .update({
      'first name': _firstNameController.text,
      'last name': _lastNameController.text,
      'email': _emailController.text,
      'language': _languageController.text
    });

    // Reauthenticate the user
    var credential = EmailAuthProvider.credential(
      email: _currentUser.email!,
      password: userDoc!['password'] ?? '', // Replace 'currentPassword' with the user's current password
    );
    await _currentUser.reauthenticateWithCredential(credential);

    // Update email in Firebase Authentication
    await _currentUser.verifyBeforeUpdateEmail(_emailController.text);
    
    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Information successfully update')),
    );
  } catch (e) {
    // Show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update email: $e')),
    );


  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  height: 700,
                  width: 350,
          
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    
                        Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start ,
                                children: [
                                
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: TextField(
                                      
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'First Name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)
                                        ),
                                        hintText: _firstNameController.text
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    hintText: _lastNameController.text
                                  ),
                                ),
                              ),
                            ),
                    
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    hintText: _emailController.text
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: _languageController,
                                  decoration: InputDecoration(
                                    labelText: 'Language',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    hintText: _languageController.text
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          

                            ElevatedButton( //translator button
                            onPressed: updateAccountInfo,
                            style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent, 
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),

                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(

                                'Confirm Changes',
                                style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 13),

                          GestureDetector(
                            onTap: (){
                              //if client push to client nav, if translator push to translator nav
                              Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => ClientNavigation()) //rename account info page
                                  );
                            },
                            child: const Text(
                              'Back to profile',
                              style: TextStyle(
                                color: Colors.blueAccent
                                
                              ),
                            
                            ),
                          )
                              
                        
                      ],
                              
                              
                    ),
                  ),
          
                )
          
              )
          
            ],
          ),
        )
        
        ),



    );
  }
}