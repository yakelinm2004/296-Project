// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          Container(color: Colors.blueGrey),
          Container(color: Colors.blueGrey),
          Container(color: Colors.blueGrey),
          Container(color: Colors.blueGrey),
          
        ],
      ),


    );
  }
}