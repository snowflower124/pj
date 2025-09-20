import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 intl 패키지 추가

// 앱의 시작점
void main() {
  runApp(const ZariApp());
}

// 앱의 루트 위젯
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

// --- 메인 스크린 및 내비게이션 ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ListingsPage(),
    ContractPage(),
    CompassAiPage(),
    InfoPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: '매물'),
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: '계약'),
          BottomNavigationBarItem(icon: Icon(Icons.compass_calibration_rounded), label: '나침반'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: '정보'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}

// --- 1. 매물 탭 페이지 (오류 수정) ---
class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Column 대신 ListView를 사용하여 작은 화면에서의 오버플로우 오류 방지
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('내 주변 매물')),
      body: ListView(
        children: [
          const DDayCard(),
          // 지도 영역의 높이를 고정하여 ListView 내에서 크기를 가질 수 있도록 함
          Container(
            height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50%를 차지
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Text("지도 영역", style: TextStyle(color: Colors.grey, fontSize: 20)),
                ),
                _buildListingPin(top: 50, left: 60),
                _buildListingPin(top: 120, left: 200),
                _buildListingPin(bottom: 80, right: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingPin({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]
        ),
        child: const Text("500/55", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// --- D-Day 계산 및 표시 위젯 (오류 수정) ---
class DDayCard extends StatefulWidget {
  const DDayCard({super.key});

  @override
  State<DDayCard> createState() => _DDayCardState();
}

class _DDayCardState extends State<DDayCard> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // 계산 로직을 별도의 함수로 분리하여 가독성 및 안정성 향상
  Map<String, dynamic> _calculateProgress() {
    if (_startDate == null || _endDate == null) {
      return {"percentage": 0.0, "text": "0.0%"};
    }

    // 종료일이 시작일보다 이전인 경우 예외 처리
    if (_endDate!.isBefore(_startDate!)) {
      return {"percentage": 100.0, "text": "날짜 오류"};
    }

    final totalDuration = _endDate!.difference(_startDate!).inDays;
    if (totalDuration <= 0) {
      // 계약 기간이 하루인 경우
      return {"percentage": 100.0, "text": "100.0%"};
    }

    final today = DateTime.now();
    final passedDuration = today.difference(_startDate!).inDays;

    if (passedDuration < 0) return {"percentage": 0.0, "text": "0.0%"};
    if (passedDuration >= totalDuration) return {"percentage": 100.0, "text": "100.0%"};

    final percentage = (passedDuration / totalDuration) * 100;
    return {"percentage": percentage, "text": "${percentage.toStringAsFixed(1)}%"};
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final double percentageValue = progress["percentage"];
    final String percentageText = progress["text"];

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateSelector("계약 시작일", _startDate, () => _selectDate(context, true)),
                const Text("~", style: TextStyle(fontSize: 16)),
                _buildDateSelector("계약 종료일", _endDate, () => _selectDate(context, false)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("D-Day", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percentageValue / 100,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(percentageText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            date != null ? DateFormat('yyyy.MM.dd').format(date) : "날짜 선택",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// --- 2. 계약 탭 페이지 ---
class ContractPage extends StatelessWidget {
  const ContractPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('계약 안심 동행')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [_buildFeatureCard(children: [
          _buildListTile(icon: Icons.checklist_rtl_rounded, color: Colors.orange, title: '단계별 계약 체크리스트', onTap: () {}),
          _buildListTile(icon: Icons.document_scanner_rounded, color: Colors.red, title: 'AI 계약서 분석', onTap: () {}),
          _buildListTile(icon: Icons.camera_alt_rounded, color: Colors.teal, title: '증거 보관함', onTap: () {}),
        ])],
      ),
    );
  }
}

// --- 3. 나침반 AI 탭 페이지 ---
class CompassAiPage extends StatelessWidget {
  const CompassAiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('나침반 AI')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [_buildFeatureCard(children: [
          _buildListTile(icon: Icons.compass_calibration_rounded, color: Colors.purple, title: 'AI 주거 상황 진단', onTap: () {}),
          _buildListTile(icon: Icons.real_estate_agent_rounded, color: Colors.blue, title: '최적 주거 형태/지역 추천', onTap: () {}),
          _buildListTile(icon: Icons.savings_rounded, color: Colors.green, title: '맞춤형 금융 상품 매칭', onTap: () {}),
        ])],
      ),
    );
  }
}

// --- 4. 정보 탭 페이지 ---
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('유용한 정보')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [_buildFeatureCard(children: [
          _buildListTile(icon: Icons.notifications_active_rounded, color: Colors.indigo, title: '맞춤형 주거 공고 알림', onTap: () {}),
          _buildListTile(icon: Icons.school_rounded, color: Colors.brown, title: '틈새 장학금 정보', onTap: () {}),
          _buildListTile(icon: Icons.wallet_giftcard_rounded, color: Colors.pink, title: '생활비 절약 꿀팁', onTap: () {}),
        ])],
      ),
    );
  }
}

// --- 5. 마이페이지 ---
class MyPage extends StatelessWidget {
  const MyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('마이페이지')),
      body: const Center(child: Text('마이페이지입니다.')),
    );
  }
}

// --- 공용 위젯 ---
Widget _buildFeatureCard({required List<Widget> children}) {
  final List<Widget> itemsWithDividers = [];
  for (int i = 0; i < children.length; i++) {
    itemsWithDividers.add(children[i]);
    if (i < children.length - 1) {
      itemsWithDividers.add(const Divider(height: 1, thickness: 0.5, indent: 56, color: Color(0xFFE0E0E0)));
    }
  }
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Column(children: itemsWithDividers),
  );
}

Widget _buildListTile({required IconData icon, required Color color, required String title, required VoidCallback onTap}) {
  return ListTile(
    leading: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
    title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    onTap: onTap,
  );
}