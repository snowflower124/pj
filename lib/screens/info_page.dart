// lib/screens/info_page.dart

import 'package:flutter/material.dart';
import 'package:zari/screens/contract_terms_page.dart'; // 새로 추가
import 'package:zari/screens/saving_tips_page.dart'; // 새로 추가
import 'package:zari/widgets/common_widgets.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('유용한 정보')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: [buildFeatureCard(children: [
          buildListTile(
              icon: Icons.notifications_active_rounded,
              color: Colors.indigo,
              title: '맞춤형 주거 공고 알림',
              onTap: () {}
          ),
          buildListTile(
              icon: Icons.school_rounded,
              color: Colors.brown,
              title: '틈새 장학금 정보',
              onTap: () {}
          ),
          buildListTile(
              icon: Icons.wallet_giftcard_rounded,
              color: Colors.pink,
              title: '생활비 절약 꿀팁',
              onTap: () {
                // 👇 saving_tips_page.dart 로 이동
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SavingTipsPage()));
              }
          ),
          // 👇 새로 추가된 버튼
          buildListTile(
              icon: Icons.book_outlined,
              color: Colors.blueGrey,
              title: '계약 핵심 용어 해설',
              onTap: () {
                // 👇 contract_terms_page.dart 로 이동
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ContractTermsPage()));
              }
          ),
        ])],
      ),
    );
  }
}