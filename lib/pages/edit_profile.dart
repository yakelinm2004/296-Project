import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/clientUI/cl_navigation.dart';
import 'package:mobile_app_296/translatorUI/t_navigation.dart';


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
  late String accountType;

  @override
  void initState() {
    
    super.initState();
    
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _languageController = TextEditingController(); 
    accountType = '';
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
    accountType = userDoc!['account type'] ?? '';
   }
     
  }

  void updateAccountInfo() async {
    try{
    //Updating instance of user info doc 
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
      password: userDoc!['password'] ?? '',
    );
    await _currentUser.reauthenticateWithCredential(credential);
    await _currentUser.verifyBeforeUpdateEmail(_emailController.text);
    

    //Info successfully updated
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Information successfully updated')),
    );

  } catch (e) {
    // Error updating email
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update email: $e')),
    );


  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 207, 216),
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

                        //First name text box
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
                    
                            //Last name text box
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
                    
                            //Email text box
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

                            //Language text box
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
                          
                            //Confirm button
                            ElevatedButton( 
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
                          const SizedBox(height: 13),

                          GestureDetector(
                            onTap: (){
                              //If account type is client, redirect to Client UI
                              if(accountType == 'Client'){
                                 Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => const ClientNavigation()) 
                                  );
                              //If account type is translator, redirect to Translator UI
                              } else if(accountType == 'Translator'){
                                Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => const TranslatorNavigation()) 
                                  );
                              }
                            
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