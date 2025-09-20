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
  late Future<List<HousingListing>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    // ApiService의 getRecommendedListings 함수를 호출
    _listingsFuture = ApiService().getRecommendedListings(widget.criteria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI 추천 매물")),
      body: FutureBuilder<List<HousingListing>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('추천 매물이 없습니다.'));
          }
          final listings = snapshot.data!;
          return ListView.builder(
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final listing = listings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("${listing.housingType} (${listing.transactionType})"),
                  subtitle: Text(listing.location),
                  trailing: Text(
                      listing.transactionType == '월세'
                          ? '${listing.deposit}/${listing.rent}'
                          : '${listing.deposit}',
                      style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}