import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/models/usermodel.dart';

import '../pages/app_home.dart';
import '../pages/edit_profile.dart';
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
  final User? _currentUser = FirebaseAuth.instance.currentUser;


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

void _confirmAccountDeletion(){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to permanently delete your account?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () { 
              _deleteAccount(); 
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.red
              ),
              
            ),
          ),
        ],
      );
    },
  ).then((value) {
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
  });
}

void _deleteAccount() async{

  try{

    DocumentSnapshot<Map<String, dynamic>>? userDoc = await FirebaseFirestore.instance
   .collection('users')
   .doc(_currentUser!.uid)
   .get();

    var credential = EmailAuthProvider.credential(
      email: _currentUser.email!, 
      password: userDoc!['password'] ?? ''
    );

    await _currentUser.reauthenticateWithCredential(credential);

    _currentUser!.delete();
    print('User account successfully deleted');

    await FirebaseFirestore.instance
      .collection('users')
      .doc(_currentUser.uid)
      .delete()
      .then((doc) => print('User document successfully deleted'),
      onError: (e) => print('Error deleting user document')
  
      );

    await FirebaseFirestore.instance
      .collection('users')
      .doc(_currentUser.uid)
      .collection('services')
      .get()
      .then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((doc) { 
        doc.reference.delete();

        });
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppHomePage())
      );
  } catch(e){
    print('Error deleting account');
  }
  

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
            ClipRRect(
              borderRadius: BorderRadiusDirectional.circular(20),
              child: Container(
                height: 420,
                width: 360,
                color: Colors.white,

                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfile())
                          );
                        },


                        child: const Row(
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
                            MaterialPageRoute(builder: (context) => LoginPage())
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 10.0),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.blue,
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

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          _confirmAccountDeletion();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.delete_forever, color: Colors.red),
                            SizedBox(width: 10.0),
                            Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0
                                      
                                      
                              ),
                            ),
                          ],
                        ),
                      ),
              
                    ),
                  ],
                ),
                
              ),
            ),
          ],
          
        )

      ),

    );
  }
}
