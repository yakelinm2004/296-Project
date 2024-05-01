// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/clientUI/cl_navigation.dart';
import 'package:mobile_app_296/models/usermodel.dart';

class UserAuthentication{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  

  //Sign Up Method
  Future<User?> signUpWitheEmailAndPassword(String email, String password, BuildContext context) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      User? user = credential.user;
      return user;
    } on FirebaseAuthException catch (e){
      if(e.code == 'weak-password'){
        print('The password provided is not strong enough');
      } else if(e.code == 'email-already-in-use'){
        print('That email is already in use');
      }
    } catch(e){
      print("Error creating user");
    }
    return null;
     
  }


  //Sign In Method
  Future<User?> signInWitheEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        print('No user found for that email.');
        
      } else if(e.code == 'wrong-password'){
        print("Incorrect password");
       
      } else{
        print("Error signing in user");
      }
      
    }
    return null;
  }

  //Handling signing in
  Future<User?> handleSignIn(BuildContext context, String email, String password) async{
    User? user = await signInWitheEmailAndPassword(email, password);
    if(user != null){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: ((context) => const ClientNavigation())
      ));
      return user;
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in failed. Please try again.')),
      );
    }
    return null;

  }


  //Storing User Information Method
  Future<bool> storeUserInformation(String email, String password, String firstName, String lastName, String accountType, String language) async{

    try{
      User? user = _auth.currentUser;
      if(user != null){
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'first name': firstName,
          'last name': lastName,
          'email': email,
          'password': password,
          'account type': accountType,
          'language': language,
          'user id': user.uid
          

        });
        return true;
      } else{
        print("Error: User is null");
        return false;
      }
     
    } catch(e){
      print("Some error occurred");
      return false;
    }
    
  }



  Future<UserModel?> getUserInformation(String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists) {
      return UserModel(
        firstName: snapshot.data()!['firstName'],
        lastName: snapshot.data()!['lastName'],
        email: snapshot.data()!['email'],
        
      );
    } else {
      print("User data not found");
      return null;
    }
  } catch (e) {
    print("Error retrieving user data: $e");
    return null;
  }
}

  

}