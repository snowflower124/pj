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
  // --- 👇 2. 시작 화면을 '나침반' 탭(인덱스 2)으로 변경 ---
  int _selectedIndex = 2;

  // --- 👇 1. 버튼 순서에 맞게 페이지 목록 순서 변경 ---
  final List<Widget> _widgetOptions = [
    const ContractPage(),     // 0번: 계약
    const ListingsPage(),     // 1번: 매물
    const CompassAiPage(),    // 2번: 나침반
    const InfoPage(),         // 3번: 정보
    const MyPage(),           // 4번: 마이페이지
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // --- 👇 1. 버튼 아이템 순서 변경 ---
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: '계약'),        // 0번
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: '매물'),     // 1번
          BottomNavigationBarItem(icon: Icon(Icons.compass_calibration_rounded), label: '나침반'), // 2번
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: '정보'),         // 3번
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),      // 4번
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