// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app_296/clientUI/cl_bookings_page.dart';
import 'package:mobile_app_296/clientUI/cl_home_screen.dart';
import 'package:mobile_app_296/clientUI/cl_profile_page.dart';

class ClientNavigation extends StatefulWidget {
  const ClientNavigation({super.key});

  @override
  State<ClientNavigation> createState() => _ClientNavigationState();
}

class _ClientNavigationState extends State<ClientNavigation> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    ClientHomePage(),
    BookingsPage(),
    CLientProfilePage()

  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 60,
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home), 
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(Icons.people), 
            label: 'Bookings'
          ),
          NavigationDestination(
            icon: Icon(Icons.person), 
            label: 'Profile'
          ),
        ],
        
      ),


    );
  }
}