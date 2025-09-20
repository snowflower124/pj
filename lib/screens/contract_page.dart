import 'package:flutter/material.dart';
import 'package:zari/screens/checklist_page.dart';
import 'package:zari/screens/evidence_locker_page.dart';
import 'package:zari/widgets/common_widgets.dart';

class ContractPage extends StatelessWidget {
  const ContractPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('계약 안심 동행')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [buildFeatureCard(children: [
          buildListTile(
            icon: Icons.checklist_rtl_rounded, color: Colors.orange, title: '새 계약서 작성',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChecklistPage())),
          ),
          buildListTile(icon: Icons.document_scanner_rounded, color: Colors.red, title: 'AI 계약서 분석', onTap: () {}),
          buildListTile(
            icon: Icons.camera_alt_rounded, color: Colors.teal, title: '문서보관함',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EvidenceLockerPage())),
          ),
        ])],
      ),
    );
  }
}