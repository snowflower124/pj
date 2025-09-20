// lib/screens/contract_terms_page.dart

import 'package:flutter/material.dart';
import 'package:zari/data/database.dart';
import 'package:zari/models/info_model.dart';

class ContractTermsPage extends StatefulWidget {
  const ContractTermsPage({super.key});

  @override
  State<ContractTermsPage> createState() => _ContractTermsPageState();
}

class _ContractTermsPageState extends State<ContractTermsPage> {
  void _showAddTermDialog() {
    final termController = TextEditingController();
    final definitionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("새로운 용어 추가"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: termController, decoration: const InputDecoration(labelText: "용어")),
            TextField(controller: definitionController, decoration: const InputDecoration(labelText: "뜻풀이")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () {
              if (termController.text.isNotEmpty && definitionController.text.isNotEmpty) {
                setState(() {
                  contractTerms.add(ContractTerm(
                    term: termController.text,
                    definition: definitionController.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("추가"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("계약 핵심 용어 해설")),
      body: ListView.builder(
        itemCount: contractTerms.length,
        itemBuilder: (context, index) {
          final term = contractTerms[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(term.term, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(term.definition, style: const TextStyle(height: 1.5)),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTermDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}