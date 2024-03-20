import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthentication{
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  

  //Sign Up Method
  Future<User?> signUpWitheEmailAndPassword(String email, String password, BuildContext context) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch(e){
      print("Error creating user");
    }
    return null;
    
  }


  //Sign In Method
  Future<User?> signInWitheEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        print('No user found for that email.');
        //wrongEmail();
      } else if(e.code == 'wrong-password'){
        print("Incorrect password");
       // wrongPassword();
      } else{
        print("Error signing in user");
      }
      
    }
    return null;
  }

  //Storing User Information Method
  Future<FirebaseFirestore?> storeUserInformation(String email, String password, String firstName, String lastName) async{

    try{
      DocumentReference<Map<String, dynamic>> credential = await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'password': password
  });
      return credential.firestore;
    } catch(e){
      print("Some error occurred");
    }
    return null;
  }
/*
  void wrongEmail(){
    showDialog(
      context: context, 
      builder: (context){
        return const AlertDialog(
          title: Text('Incorrect Email')
        );
      }

    );

  }

  void wrongPassword(){
    showDialog(
      context: context, 
      builder: (context){
        return const AlertDialog(
          title: Text('Incorrect Password')
        );
      }

    );
  }
*/


}