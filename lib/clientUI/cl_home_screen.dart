// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_296/clientUI/booking_form.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  
  List _allResults = [];
  List _searchResults = [];
  //bool _isSearching = false;
  final searchController = TextEditingController();

  @override
  void initState() {
    
    super.initState();
    _getAllUsers();
  }

  _getAllUsers() async{
    QuerySnapshot data = await FirebaseFirestore.instance
      .collection('users')
      .where('account type', isEqualTo: 'Translator')
      .orderBy('language')
      .get();

      setState(() {
        _allResults = data.docs;
        _searchResults = _allResults;
      });
  }
  
  _onSearchChanged(String query){
  
    setState(() {
      _searchResults = _allResults.where((doc) {
      if (doc.data().containsKey('language')) {
        String language = doc['language'].toString().toLowerCase();
        print('Document language: $language');
        return language.contains(query.toLowerCase());
      } else{
         return false;
      }
        
      }).toList();
    });
  }

  getUserStream() async{
    var data = await FirebaseFirestore.instance
    .collection('users')
    .where('account type', isGreaterThanOrEqualTo: 'Translator')
    .get();

    setState(() {
      _allResults = data.docs;
      _searchResults = _allResults;
    });
    
    
    print('Number of documents fetched: ${data.docs.length}');
    data.docs.forEach((doc) {
      print('Document ID: ${doc.id}');
      print('Document data: ${doc.data()}');
    });
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 184, 207, 216),
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 50, right: 20) ,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text(
                    'Welcome!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),
                  ),
                  Text(
                    'Start searching for translators',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20                      
                    ), 
                  ),
                  SizedBox(height: 10),

                  //Search bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white
                    ),
                    child: TextField(
                      onChanged: (value) => _onSearchChanged(value),
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Type in a language',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white)
                        )
                      ),
                    
                    ),
                  ),
                  
                  //if(_isSearching)
                  //Displays list of available translators
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        var result = _searchResults[index];
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                         
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      result['first name'] + ' ' + result['last name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,

                                      ),
                                      ),

                                    Text(
                                      'Language: ' + result['language'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300

                                      ),
                                    ),  
                                  ],
                                                                                                           
                                  
                                ),
                              ),
                              SizedBox(width: 30),

                              //Booking button
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: const Color.fromARGB(255, 8, 86, 48),
                                onSurface: Color.fromARGB(255, 0, 0, 0),
                              ),
                                onPressed: () => _bookingForm(result['user id']),
                                child: Text('Book Now'),
                              )
                            ],
                          ),
                        );
                      }),
                ],
              ),
              
            ],
          ),
        )
      ),
    );

   
  }

  void _bookingForm(String translatorId) {
    print('Translator ID: ' + translatorId);
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => BookingForm(translatorId: translatorId))
  );
  }
}