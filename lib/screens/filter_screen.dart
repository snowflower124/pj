// lib/screens/filter_screen.dart
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? _transactionType = '월세';
  final Set<String> _housingTypes = {'아파트'};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("상세 필터", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Text("거래 유형", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: ['월세', '전세', '매매'].map((type) => ChoiceChip(
              label: Text(type),
              selected: _transactionType == type,
              onSelected: (selected) => setState(() => _transactionType = type),
            )).toList(),
          ),
          const SizedBox(height: 24),
          const Text("매물 종류", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: ['아파트', '오피스텔', '다세대주택', '원룸'].map((type) => FilterChip(
              label: Text(type),
              selected: _housingTypes.contains(type),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _housingTypes.add(type);
                  } else {
                    _housingTypes.remove(type);
                  }
                });
              },
            )).toList(),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // TODO: 필터링된 결과로 지도 업데이트 로직 구현
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("필터 적용하기", style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}