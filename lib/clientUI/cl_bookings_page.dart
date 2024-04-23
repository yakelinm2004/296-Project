import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}



class _BookingsPageState extends State<BookingsPage> {
   late User _currentUser;
   String? translatorId;
   String? translatorFirstName;
   String? translatorLastName;

   List<DocumentSnapshot> _bookings = [];
   List<DocumentSnapshot> _translators = [];




  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getAllBookings();
    //_getTranslatorInfo();

  }

   _getCurrentUser(){
    _currentUser = FirebaseAuth.instance.currentUser!;
   }
  
  void _getAllBookings() async {
    String userId = _currentUser.uid;
    
    try{
      QuerySnapshot<Map<String, dynamic>> bookingSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .get();

      
        setState(() {
          _bookings = bookingSnapshot.docs;
          print('successfully retrieved data $_bookings');

          for (DocumentSnapshot booking in _bookings) {
            setState(() {
               final translatorId = booking['translator id'];
               _getTranslatorInfo(translatorId);
              
            });
            print(translatorId);
            //_getTranslatorInfo(translatorId);
    }
        });

        
      
        
      }catch(e){
        print('Error retrieving bookings: $e');
      }
    


  }

  void _getTranslatorInfo(String? translatorId) async{
    if(translatorId == null) return;
    
    try{

      DocumentSnapshot<Map<String, dynamic>> translatorDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(translatorId)
      .get();

      setState(() {
        //_translators = translatorDoc.get(field);
        translatorFirstName = translatorDoc.get('first name').toString();
        //print(translatorFirstName);
        translatorLastName = translatorDoc.get('last name').toString();
        print('$translatorFirstName $translatorLastName');

      });
      
    } catch(e){
      print('Unable to retrieve translator info: $e');
    }
    
    

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: _bookings.isEmpty ?
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
                  'Upcoming Bookings',
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
                itemCount: _bookings.length,
                itemBuilder: (context, index){
                  var booking = _bookings[index];
                
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
                                'Translator: ' + booking['first name'] + ' ' + booking['last name'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
              
                                ),
                              ),
              
                              Text(
                                'Date: ' + booking['date'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
              
                                ),
                              ),
              
                              Text(
                                'Description: ' + booking['description'],
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