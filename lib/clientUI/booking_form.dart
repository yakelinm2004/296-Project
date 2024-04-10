// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; 


class BookingForm extends StatefulWidget {
  final String translatorId;
  const BookingForm({Key? key, required this.translatorId}) : super(key: key);

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  DateTime currentDate = DateTime.now();
  late TextEditingController _descriptionController;
  

  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _getCurrentUser(){
    _currentUser = FirebaseAuth.instance.currentUser!;
  }
  
  void _onDaySelected(DateTime selectedDate, DateTime focusedDay){
    setState(() {
      currentDate = selectedDate;
    });
  }

  Future<void> _saveBooking() async {
    String userId = _currentUser.uid;
    bool clientBookingSaved = false;
    bool translatorServiceSaved = false;

    try{
      CollectionReference clientBookings = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('bookings');

      clientBookings.add({
        'translator id': widget.translatorId,
        'date': DateFormat('EEE, M/d/y').format(currentDate),
        'description': _descriptionController.text
      });

      clientBookingSaved = true;
      print('Booking successfully saved');

    } catch(e){
      print('Unable to store client booking');
    }

    try{
      CollectionReference translatorServices = FirebaseFirestore.instance
      .collection('users')
      .doc(widget.translatorId)
      .collection('services');

      translatorServices.add({
        'client id': _currentUser.uid,
        'date': DateFormat('EEE, M/d/y').format(currentDate),
        'description': _descriptionController.text
      });

      translatorServiceSaved = true;
      print('Service successfully saved');

    } catch(e){
      print('Unable to store translator service');
    }

    if(clientBookingSaved && translatorServiceSaved){
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Booking successfully saved'),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                child: Text('Ok'),
                
              )
            ],

          );
        }
      );

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 207, 216),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 117, 137),
        elevation: 0,
        title: const Text(
          'Schedule a Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            
          ),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            /*
            const Text(
              'When would you like to book?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400
              ),
        
            ),
            */
            const Divider(color: Colors.black12,),
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true
              ),

              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (selectedDate) => isSameDay(selectedDate, currentDate),
              focusedDay: currentDate,
              firstDay: DateTime.utc(2024, 4, 10),
              lastDay: DateTime.utc(2030, 4, 10),
              onDaySelected: _onDaySelected,
            
            ),
            const Divider(color: Colors.black12,),

            Text(
             'Selected Date: ${DateFormat('EEE, M/d/y').format(currentDate)}',
             style: const TextStyle(
              fontSize: 18
              
             ),

            ),
            const SizedBox(height: 30),

            TextField(
              decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Please enter a brief description of your desired service ',
              ),
              controller: _descriptionController,
              style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 40),


              ElevatedButton(
                onPressed: _saveBooking, 
                style: ElevatedButton.styleFrom(
                  primary:  Color.fromARGB(255, 97, 126, 141), 
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Schedule',
                    style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    ),
                  ),
                ),
              ),
          ],
          
        ),
      ),
    );
  }

  

}