import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zari/data/database.dart';
import 'package:zari/models/contract_model.dart';
import 'package:zari/screens/checklist_page.dart';

class EvidenceLockerPage extends StatefulWidget {
  const EvidenceLockerPage({super.key});
  @override
  State<EvidenceLockerPage> createState() => _EvidenceLockerPageState();
}

class _EvidenceLockerPageState extends State<EvidenceLockerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("문서보관함")),
      body: savedContracts.isEmpty
          ? const Center(child: Text("저장된 계약이 없습니다."))
          : ListView.builder(
        itemCount: savedContracts.length,
        itemBuilder: (context, index) {
          final contract = savedContracts[index];
          final isCompleted = contract.status == ContractStatus.completed;
          return ListTile(
            title: Text(contract.name),
            subtitle: Text("${contract.type} 계약 - ${DateFormat('yyyy.MM.dd').format(contract.completionDate)} 저장"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isCompleted ? "완료" : "진행 중", style: TextStyle(color: isCompleted ? Colors.green : Colors.orange)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () async {
              if (isCompleted) {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => ContractDetailsPage(contract: contract)));
              } else {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistPage(existingContract: contract)));
              }
              setState(() {});
            },
          );
        },
      ),
    );
  }
}

class ContractDetailsPage extends StatelessWidget {
  final Contract contract;
  const ContractDetailsPage({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final allAttachments = contract.items.expand((item) => item.attachments).toList();
    return Scaffold(
      appBar: AppBar(title: Text(contract.name)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("${contract.type} 계약 상세내용", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...contract.items.map((item) => ListTile(
            leading: Icon(item.isChecked ? Icons.check_box : Icons.check_box_outline_blank, color: item.isChecked ? Colors.green : Colors.grey),
            title: Text(item.title),
            subtitle: Text("첨부파일: ${item.attachments.length}개"),
          )),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("전체 첨부파일 목록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          allAttachments.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("첨부된 파일이 없습니다.")))
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: allAttachments.length,
            itemBuilder: (context, index) {
              final file = allAttachments[index];
              if (file.path.toLowerCase().endsWith('.jpg') || file.path.toLowerCase().endsWith('.jpeg') || file.path.toLowerCase().endsWith('.png')) {
                return Image.file(File(file.path), fit: BoxFit.cover);
              } else {
                return Container(color: Colors.grey[300], child: const Icon(Icons.videocam));
              }
            },
          ),
        ],
      ),
    );
  }
}