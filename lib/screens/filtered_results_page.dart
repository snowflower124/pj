import 'package:flutter/material.dart';
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';
import 'package:zari/services/api_service.dart';

class FilteredResultsPage extends StatefulWidget {
  final AiDiagnosisResponse criteria;

  const FilteredResultsPage({super.key, required this.criteria});

  @override
  State<FilteredResultsPage> createState() => _FilteredResultsPageState();
}

class _FilteredResultsPageState extends State<FilteredResultsPage> {
  // ApiService 객체를 생성하고 getFilteredListings 함수를 호출하는 Future
  late Future<List<HousingListing>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    // initState에서 API 호출을 시작
    _listingsFuture = ApiService().getFilteredListings(widget.criteria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI 추천 매물"),
      ),
      body: FutureBuilder<List<HousingListing>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          // 로딩 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 에러가 발생했을 때
          if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          }
          // 데이터가 없을 때
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('추천 매물이 없습니다.'));
          }
          // 성공적으로 데이터를 받아왔을 때
          final listings = snapshot.data!;
          return ListView.builder(
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final listing = listings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(listing.housingType),
                  subtitle: Text(listing.location),
                  trailing: Text('월 ${listing.rent}만원'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}