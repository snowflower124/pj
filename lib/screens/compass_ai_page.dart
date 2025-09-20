// lib/screens/compass_ai_page.dart

import 'package:flutter/material.dart';
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/screens/ai_diagnosis_page.dart';
import 'package:zari/widgets/common_widgets.dart';
import 'package:zari/widgets/d_day_card.dart';

class CompassAiPage extends StatefulWidget {
  const CompassAiPage({super.key});
  @override
  State<CompassAiPage> createState() => _CompassAiPageState();
}

class _CompassAiPageState extends State<CompassAiPage> {
  // AI 진단 결과를 AiDiagnosisResponse 객체로 저장
  AiDiagnosisResponse? _aiResults;

  void _navigateToDiagnosisPage() async {
    final results = await Navigator.push<AiDiagnosisResponse>(
      context,
      MaterialPageRoute(builder: (context) => const AiDiagnosisPage()),
    );

    if (mounted && results != null) {
      setState(() {
        _aiResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('나침반 AI')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [
          const DDayCard(),
          const SizedBox(height: 20),
          _buildAiResultsCard(),
          const SizedBox(height: 8),
          buildFeatureCard(children: [
            buildListTile(
              icon: Icons.compass_calibration_rounded,
              color: Colors.purple,
              title: 'AI 주거 상황 진단',
              onTap: _navigateToDiagnosisPage,
            ),
            buildListTile(icon: Icons.real_estate_agent_rounded, color: Colors.blue, title: '최적 주거 형태/지역 추천', onTap: () {}),
            buildListTile(icon: Icons.savings_rounded, color: Colors.green, title: '맞춤형 금융 상품 매칭', onTap: () {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildAiResultsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AI 상황 판단 결과", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _aiResults != null
                  ? _buildDiagnosisResult(_aiResults!)
                  : _buildDiagnosisPrompt(),
            ),
          ],
        ),
      ),
    );
  }

  // 결과 데이터를 AiDiagnosisResponse 객체에서 직접 가져와 표시
  Widget _buildDiagnosisResult(AiDiagnosisResponse results) {
    return Column(
      key: const ValueKey('result'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• 추천 월세: ${results.recommendedRent}만원"),
        const SizedBox(height: 4),
        Text("• 추천 전세: ${results.recommendedJeonse}만원"),
        const SizedBox(height: 4),
        Text("• 추천 주거 형태: ${results.recommendedHousingType}"),
      ],
    );
  }

  Widget _buildDiagnosisPrompt() {
    return const Text(
      key: ValueKey('prompt'),
      "AI를 통해 여러분들의 상황을 진단 받고\n최적의 월세/전세 비용을 추천 받으세요!",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, height: 1.5),
    );
  }
}