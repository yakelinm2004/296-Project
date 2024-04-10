import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? accountType;
  final String? language;
  
  

UserModel({
  this.uid, 
  this.firstName, 
  this.lastName, 
  this.email, 
  this.accountType,
  this.language
}); 


factory UserModel.fromFirestore(DocumentSnapshot doc){
  return UserModel(
    uid: doc['user id'],
    firstName: doc['first name'],
    lastName: doc['last name'],
    email: doc['email'],
    accountType: doc['account type'],
    language: doc['language']

  );
}





  
}


