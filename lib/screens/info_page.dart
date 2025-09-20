import 'package:flutter/material.dart';
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
          buildListTile(icon: Icons.notifications_active_rounded, color: Colors.indigo, title: '맞춤형 주거 공고 알림', onTap: () {}),
          buildListTile(icon: Icons.school_rounded, color: Colors.brown, title: '틈새 장학금 정보', onTap: () {}),
          buildListTile(icon: Icons.wallet_giftcard_rounded, color: Colors.pink, title: '생활비 절약 꿀팁', onTap: () {}),
        ])],
      ),
    );
  }
}