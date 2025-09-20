// lib/screens/compass_ai_page.dart

import 'package:flutter/material.dart';
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/screens/ai_diagnosis_page.dart';
import 'package:zari/screens/filtered_results_page.dart';
import 'package:zari/widgets/common_widgets.dart';
import 'package:zari/widgets/d_day_card.dart';

class CompassAiPage extends StatefulWidget {
  const CompassAiPage({super.key});
  @override
  State<CompassAiPage> createState() => _CompassAiPageState();
}

class _CompassAiPageState extends State<CompassAiPage> {
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
            buildListTile(icon: Icons.compass_calibration_rounded, color: Colors.purple, title: 'AI 주거 상황 진단', onTap: _navigateToDiagnosisPage),
            buildListTile(
              icon: Icons.real_estate_agent_rounded, color: Colors.blue,
              title: '최적 주거 형태/지역 추천',
              onTap: () {
                if (_aiResults != null) {
                  // 필터링 로직 대신, AI 결과 자체를 결과 페이지로 전달
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FilteredResultsPage(criteria: _aiResults!),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('AI 주거 상황 진단을 먼저 받아주세요.'),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
            ),
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
              child: _aiResults != null ? _buildDiagnosisResult(_aiResults!) : _buildDiagnosisPrompt(),
            ),
          ],
        ),
      ),
    );
  }

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
      key: ValueKey('prompt'), "AI를 통해 여러분들의 상황을 진단 받고\n최적의 월세/전세 비용을 추천 받으세요!",
      textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, height: 1.5),
    );
  }
}