import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreData{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;

  FirestoreData(this._user);
  getAccountType(String uid) {}
  //final String _firstname = '';
  //final String _lastName = '';
}


Future<Map<String, dynamic>> getUserData(String userID) async {
  try {
    // Query used to find user docs containing userID
    QuerySnapshot<Map<String, dynamic>> userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('user id', isEqualTo: userID)
        .limit(1)
        .get();

    // Check if any documents match the query
    if (userDocs.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = userDocs.docs.first;
      String firstName = userDoc.get('first name');
      String lastName = userDoc.get('last name');
      String email = userDoc.get('email');
      String accountType = userDoc.get('account type');
      String language = userDoc.get('language');

      // Return user data as a map
      return {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'accountType': accountType,
        'language': language
      };
    } else {
      // No document found with the specified user ID
      print('No user document found with ID: $userID');
    }
  } catch (e) {
    // Handle errors
    print('Error retrieving user data: $e');
  }
  return {}; // Return an empty map if there's an error or no document found
}

Future<String?> getAccountType(String userID) async {
    try {
      // Query used to find user docs containing userID
      QuerySnapshot<Map<String, dynamic>> userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('user id', isEqualTo: userID)
          .limit(1)
          .get();

      // Check if any documents match the query
      if (userDocs.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = userDocs.docs.first;
        String? accountType = userDoc.get('account type');

        return accountType; // Return account type if found
      } else {
        // No document found with the specified user ID
        print('No user document found with ID: $userID');
      }
    } catch (e) {
      // Handle errors
      print('Error retrieving account type: $e');
    }
    return null; // Return null if there's an error or no document found
  }

  