// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app_296/translatorUI/t_profile_page.dart';
import 'package:mobile_app_296/translatorUI/t_services_page.dart';


//Main component for translator bottom navigation bar
class TranslatorNavigation extends StatefulWidget {
  const TranslatorNavigation({super.key});

  @override
  State<TranslatorNavigation> createState() => _TranslatorNavigationState();
}

class _TranslatorNavigationState extends State<TranslatorNavigation> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    TranslatorServicesPage(),
    TranslatorProfilePage()

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
            icon: Icon(Icons.people), 
            label: 'Services'
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