

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/user%20authentication/firestore_data.dart';

class TranslatorServicesPage extends StatefulWidget {
  const TranslatorServicesPage({super.key});

  @override
  State<TranslatorServicesPage> createState() => _TranslatorServicesPageState();
}

class _TranslatorServicesPageState extends State<TranslatorServicesPage> {
  late User _currentUser;
  String? clientId;
   String? clientFirstName;
   String? clientLastName;
  //late FirestoreData userData;

  List<DocumentSnapshot> _services = [];
  
  @override
  void initState(){
    _getCurrentUser();
    _getAllBookings();

  }

  _getCurrentUser(){
    _currentUser = FirebaseAuth.instance.currentUser!;
   }
  
  void _getAllBookings() async {
    String userId = _currentUser.uid;
    
    try{
      QuerySnapshot<Map<String, dynamic>> serviceSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('services')
        .get();

      
        setState(() {
          _services = serviceSnapshot.docs;
          print('successfully retrieved data $_services');

          for (DocumentSnapshot service in _services) {
            setState(() {
               final clientId = service['client id'];
               _getClientInfo(clientId);
              
            });
            //print(clientId);
            //_getTranslatorInfo(translatorId);
    }
        });

        
      
        
      }catch(e){
        print('Error retrieving bookings: $e');
      }
    


  }

  void _getClientInfo(String? clientId) async{
    if(clientId == null) return;
    
    try{

      DocumentSnapshot<Map<String, dynamic>> clientDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(clientId)
      .get();

      setState(() {
        //_translators = translatorDoc.get(field);
        clientFirstName = clientDoc.get('first name').toString();
        //print(translatorFirstName);
        clientLastName = clientDoc.get('last name').toString();
        print('$clientFirstName $clientLastName');

      });
      
    } catch(e){
      print('Unable to retrieve translator info: $e');
    }
    
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: _services.isEmpty ?
        const Center(
          child: Text(
            'No upcoming bookings',
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 15.0
            ),
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SafeArea(
                child: Text(
                  'You Have New Bookings!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  ),
                )
              ),
              ListView.separated(
                padding: EdgeInsets.fromLTRB(0, 13, 0, 0) ,
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: _services.length,
                itemBuilder: (context, index){
                  var service = _services[index];
                
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    ),
              
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                //try to fix adding client name to translator's services documents
                                'Client: ' + service['first name'] + ' ' + service['last name'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
              
                                ),
                              ),
              
                              Text(
                                'Date: ' + service['date'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
              
                                ),
                              ),
              
                              Text(
                                'Description: ' + service['description'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
              
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  );
                }
              ),
            ],
          ),
        )

    );
  }
}