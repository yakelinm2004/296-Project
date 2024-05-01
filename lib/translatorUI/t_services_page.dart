

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
               clientId = service['client id'];
               _getClientInfo(clientId);
              
            });
           
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

  void _declineService(DocumentSnapshot serviceSnapshot) async {

    try{

      final bookingId = serviceSnapshot['client booking id'];
      final clientId = serviceSnapshot['client id'];

      //Deleting booking doc from client booking collection
       await FirebaseFirestore.instance
      .collection('users')
      .doc(clientId)
      .collection('bookings')
      .doc(bookingId)
      .delete();
      print('Successfully cancelled booking for client');

      //Deleting services doc from translator's booking dollection
       await FirebaseFirestore.instance
      .collection('users')
      .doc(_currentUser.uid)
      .collection('services')
      .where('client booking id', isEqualTo: bookingId)
      .get()
      .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) { 
          doc.reference.delete();
        });
      });

      setState(() {
        _services.removeWhere((service) => service.id == serviceSnapshot.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking cancelled successfully')),
      );
      print('Successfully removed service from translator');
  

    } catch(e){
      print("Error cancelling booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to cancel booking. Please try again')),
    );
    }
    


  }

  void _confirmDecline(DocumentSnapshot serviceSnapshot){
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Decline Booking'),
        content: Text('Are you sure you want to decline this booking?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _declineService(serviceSnapshot); // Proceed with cancellation
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );


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
                        ),

                         ElevatedButton(
                          style: TextButton.styleFrom(
                          primary: const Color.fromARGB(255, 8, 86, 48),
                          onSurface: Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: ()=> _confirmDecline(service),
                          child: const Text(                        
                            'Decline',
                            style: TextStyle(
                              color: Colors.red
                            ),

                          ),
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