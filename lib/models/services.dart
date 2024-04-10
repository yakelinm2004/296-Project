import 'package:cloud_firestore/cloud_firestore.dart';

class Services{
  final String? uid;
  final String? date;
  final String? description;

  
  

Services({
  this.uid, 
  this.date,
  this.description
}); 


factory Services.fromFirestore(DocumentSnapshot doc){
  return Services(
    uid: doc['user id'],
    firstName: doc['first name'],
    lastName: doc['last name'],
    email: doc['email'],
    accountType: doc['account type'],
    language: doc['language']

  );
}





  
}


