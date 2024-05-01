import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<Map<String, dynamic>> getUserData(String userID) async {
  try {
    // Snapshot of user's document containing account info
    DocumentSnapshot<Map<String, dynamic>> userDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get();

    
    if (userDocs != null) {
      String firstName = userDocs['first name'];
      String lastName = userDocs['last name'];
      String email = userDocs['email'];
      String accountType = userDocs['account type'];
      String language = userDocs['language'];
      
      return {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'accountType': accountType,
        'language': language
       
      };
    } else {
      // No document found 
      print('No user document found with ID: $userID');
    }
  } catch (e) {
    // Handle errors
    print('Error retrieving user data: $e');
  }
  return {}; //empty map if there's an error or no document found
}
