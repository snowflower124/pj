import 'dart:ui';
import 'package:flutter/material.dart';

// 앱의 메인 컬러 및 텍스트 스타일 정의
const Color primaryPurple = Color(0xFF6E42D0);
const Color darkPurple = Color(0xFF2C1A52);
const Color subtleTextColor = Color(0xFF555555);

const TextStyle heroHeadline = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: darkPurple,
  height: 1.3,
);

const TextStyle heroSubheadline = TextStyle(
  fontSize: 18,
  color: subtleTextColor,
  height: 1.5,
);

// 앱 실행
void main() {
  runApp(const ZariApp());
}

class ZariApp extends StatelessWidget {
  const ZariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZARI',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Inter', // 폰트는 pubspec.yaml에 추가 필요
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// 메인 페이지 (StatefulWidget으로 애니메이션 관리)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FD),
      body: Stack(
        children: [
          // 1. 배경 그라데이션
          const BackgroundGradient(),

          // 2. 메인 스크롤 컨텐츠
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120), // 헤더 공간 확보
                const HeroSection(),
                const SizedBox(height: 80),
                // 애니메이션과 함께 나타나는 기능 카드들
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: const FeaturesSection(),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // 3. 상단에 고정되는 헤더
          const FrostedAppBar(),
        ],
      ),
    );
  }
}

// 반투명 유리 효과가 적용된 앱 바 (헤더)
class FrostedAppBar extends StatelessWidget {
  const FrostedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 10),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.05)))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ZARI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryPurple)),
              Row(
                children: [
                  _navItem('AI 진단'),
                  const SizedBox(width: 20),
                  _navItem('계약 가이드'),
                  // 화면이 작을 경우 나머지 메뉴는 생략하거나 다른 UI로 처리
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: subtleTextColor));
  }
}

// 배경 그라데이션 위젯
class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.8, -0.9),
          radius: 0.8,
          colors: [Color.fromRGBO(110, 66, 208, 0.1), Colors.transparent],
        ),
      ),
    );
  }
}

// 히어로 섹션 위젯
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const Text(
            '지원 사각지대에서 막막했다면,\n이제 당신의 자리를 찾아보세요.',
            textAlign: TextAlign.center,
            style: heroHeadline,
          ),
          const SizedBox(height: 20),
          const Text(
            'ZARI는 정보가 부족한 대학생의 첫 주거 독립을 위한\n가장 똑똑하고 안전한 나침반입니다.',
            textAlign: TextAlign.center,
            style: heroSubheadline,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
              shadowColor: primaryPurple.withOpacity(0.4),
            ),
            child: const Text(
              '내 상황 진단하고 솔루션 받기 →',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

// 기능 카드 섹션 위젯
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap 위젯은 화면 너비에 따라 자동으로 줄바꿈을 해줘 반응형 UI에 유용합니다.
    return Wrap(
      spacing: 20, // 가로 간격
      runSpacing: 20, // 세로 간격
      alignment: WrapAlignment.center,
      children: const [
        FeatureCard(icon: '🧭', title: '나침반 AI', description: '내 소득과 상황에 딱 맞는\n주거 형태, 대출, 지원금을\nAI가 찾아 추천해 줘요.'),
        FeatureCard(icon: '📄', title: '계약 안심 동행', description: '어려운 부동산 계약 과정,\n체크리스트와 AI 분석으로\n사기 위험 없이 안전하게.'),
        FeatureCard(icon: '💰', title: '숨은 지원금 찾기', description: '여기저기 흩어진 정부, 민간\n지원금과 틈새 장학금 정보를\n한곳에서 놓치지 마세요.'),
      ],
    );
  }
}

// 개별 기능 카드 위젯
class FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 300, // 카드의 기본 너비
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkPurple)),
              const SizedBox(height: 10),
              Text(description, textAlign: TextAlign.center, style: TextStyle(color: subtleTextColor, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}