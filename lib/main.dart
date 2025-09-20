import 'package:flutter/material.dart';

// 앱의 시작점
void main() {
  runApp(const ZariApp());
}

// 앱의 루트 위젯 - '자리(ZARI)' 앱
class ZariApp extends StatelessWidget {
  const ZariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '자리 (ZARI)',
      debugShowCheckedModeBanner: false,
      // 앱의 전반적인 테마 설정
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // 앱의 기본 색상 견본
        scaffoldBackgroundColor: const Color(0xFFF2F2F7), // iCloud 스타일의 배경색
        fontFamily: 'Pretendard', // (선택) Pretendard와 같은 깔끔한 한글 폰트 추천
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2F2F7), // 배경과 동일한 AppBar 색상
          foregroundColor: Colors.black, // AppBar 텍스트 및 아이콘 색상
          elevation: 0, // 그림자 제거로 플랫한 디자인
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        // 카드 테마 설정
        cardTheme: CardThemeData( // CardThemeData로 타입 수정
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// 하단 탭 네비게이션을 관리하는 메인 스크린
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 하단 탭에 연결될 페이지들
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(), // 홈 (핵심 기능 대시보드)
    Center(child: Text('계약 안심 동행 페이지')),
    Center(child: Text('유용한 정보 페이지')),
    Center(child: Text('마이페이지')),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: '계약',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: '정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple, // 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // 탭 고정
        showUnselectedLabels: true, // 선택되지 않은 라벨도 표시
      ),
    );
  }
}

// '자리(ZARI)'의 핵심 기능이 반영된 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자리 (ZARI)'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildHeaderCard(),
          const SizedBox(height: 20),

          // --- 2.1. 나침반 AI 섹션 ---
          _buildSectionHeader("나침반 AI: 내 상황 진단하기"),
          _buildFeatureCard(
            children: [
              _buildListTile(
                icon: Icons.compass_calibration_rounded,
                color: Colors.purple,
                title: 'AI 주거 상황 진단',
                subtitle: '내 소득과 조건에 맞는 자리 찾기',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.real_estate_agent_rounded,
                color: Colors.blue,
                title: '최적 주거 형태/지역 추천',
                subtitle: '쉐어하우스, LH, 역세권 다세대주택 등',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.savings_rounded,
                color: Colors.green,
                title: '맞춤형 금융 상품 매칭',
                subtitle: '버팀목 전세자금대출 등 정부 지원 연결',
                onTap: () {},
              ),
            ],
          ),

          // --- 2.2. 계약 안심 동행 섹션 ---
          _buildSectionHeader("계약 안심 동행: 안전한 계약"),
          _buildFeatureCard(
            children: [
              _buildListTile(
                icon: Icons.checklist_rtl_rounded,
                color: Colors.orange,
                title: '단계별 계약 체크리스트',
                subtitle: '집 알아보기부터 이사까지 전 과정 가이드',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.document_scanner_rounded,
                color: Colors.red,
                title: 'AI 계약서 분석',
                subtitle: '독소 조항, 위험 특약 자동 스캔 및 경고',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.camera_alt_rounded,
                color: Colors.teal,
                title: '증거 보관함',
                subtitle: '하자 발생 대비 집 내부 사진/상태 기록',
                onTap: () {},
              ),
            ],
          ),

          // --- 정보 탐색 섹션 ---
          _buildSectionHeader("유용한 정보: 기회 잡기"),
          _buildFeatureCard(
            children: [
              _buildListTile(
                icon: Icons.notifications_active_rounded,
                color: Colors.indigo,
                title: '맞춤형 주거 공고 알림',
                subtitle: 'LH/SH 청년 주택, 행복주택 등',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.school_rounded,
                color: Colors.brown,
                title: '틈새 장학금 정보',
                subtitle: '민간 재단, 기업, 동문회 장학금',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.wallet_giftcard_rounded,
                color: Colors.pink,
                title: '생활비 절약 꿀팁',
                subtitle: '알뜰교통카드, 청년 전용 금융 상품 등',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // 상단 헤더 카드 위젯
  Widget _buildHeaderCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "'투명인간'이 된 청년들을 위한\n첫 자립의 동반자, 자리",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "흩어져 있는 정보를 모아\n안전하고 합리적인 '나의 자리'를 찾아보세요.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 기능 목록을 담는 카드 위젯
  Widget _buildFeatureCard({required List<Widget> children}) {
    return Card(
      child: Column(children: children),
    );
  }

  // 섹션 제목 위젯
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 16.0, bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 카드 내부에 들어갈 리스트 타일 위젯 (부제목 추가)
  Widget _buildListTile({
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle, // 부제목 추가
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 13)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}