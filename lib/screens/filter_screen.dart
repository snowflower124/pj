import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // 필터 선택 값을 저장하는 변수
  Set<String> _transactionTypes = {'월세'};
  Set<String> _housingTypes = {'아파트'};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 화면 높이의 70% 차지
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 핸들
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

          // 제목
          Text(
              "상세 필터",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 24),

          // 거래 유형 필터
          const Text("거래 유형", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: ['월세', '전세', '매매'].map((type) {
              return FilterChip(
                label: Text(type),
                selected: _transactionTypes.contains(type),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _transactionTypes.add(type);
                    } else {
                      _transactionTypes.remove(type);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 매물 종류 필터
          const Text("매물 종류", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: ['아파트', '오피스텔', '다세대주택', '원룸'].map((type) {
              return FilterChip(
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
              );
            }).toList(),
          ),

          // 하단 버튼과의 공간을 채우는 Spacer
          const Spacer(),

          // 필터 적용하기 버튼
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final filterData = {
                  'transactionTypes': _transactionTypes,
                  'housingTypes': _housingTypes,
                };
                Navigator.pop(context, filterData);
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