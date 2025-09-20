// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:zari/screens/compass_ai_page.dart';
import 'package:zari/screens/contract_page.dart';
import 'package:zari/screens/info_page.dart';
import 'package:zari/screens/listings_page.dart';
import 'package:zari/screens/my_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;

  final List<Widget> _widgetOptions = [
    const ContractPage(),
    const ListingsPage(),
    const CompassAiPage(),
    const InfoPage(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: '계약'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: '매물'),
          BottomNavigationBarItem(icon: Icon(Icons.compass_calibration_rounded), label: '나침반'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: '정보'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}