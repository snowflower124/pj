// lib/screens/saving_tips_page.dart

import 'package:flutter/material.dart';
import 'package:zari/data/database.dart';
import 'package:zari/models/info_model.dart';

class SavingTipsPage extends StatefulWidget {
  const SavingTipsPage({super.key});

  @override
  State<SavingTipsPage> createState() => _SavingTipsPageState();
}

class _SavingTipsPageState extends State<SavingTipsPage> {
  void _showAddTipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("새로운 꿀팁 추가"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "제목")),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: "내용")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                setState(() {
                  savingTips.add(SavingTip(
                    title: titleController.text,
                    content: contentController.text,
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
      appBar: AppBar(title: const Text("생활비 절약 꿀팁")),
      body: ListView.builder(
        itemCount: savingTips.length,
        itemBuilder: (context, index) {
          final tip = savingTips[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(tip.content, style: const TextStyle(height: 1.5)),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTipDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}