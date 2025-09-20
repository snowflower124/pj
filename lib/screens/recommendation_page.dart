import 'package:flutter/material.dart';
import 'package:zari/models/recommendation_model.dart';

class RecommendationPage extends StatelessWidget {
  // 생성자를 통해 추천 리스트를 전달받음
  final List<HousingRecommendation> recommendations;
  const RecommendationPage({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("AI 추천 주거 환경"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          return _buildRecommendationCard(context, recommendations[index]);
        },
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, HousingRecommendation item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.housingType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                Text("적합도 ${item.matchScore}%", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.location, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text("보증금 ${item.deposit}만원 / 월세 ${item.rent}만원", style: const TextStyle(color: Colors.black54)),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text("추천 사유: ${item.reason}", style: const TextStyle(fontStyle: FontStyle.italic))),
              ],
            )
          ],
        ),
      ),
    );
  }
}