import 'package:flutter/material.dart';
import 'package:zari/screens/main_screen.dart'; // 수정된 경로

void main() {
  runApp(const ZariApp());
}

class ZariApp extends StatelessWidget {
  const ZariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '자리 (ZARI)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        fontFamily: 'Pretendard',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2F2F7),
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}