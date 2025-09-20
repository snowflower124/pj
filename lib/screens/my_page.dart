import 'package:flutter/material.dart';
import 'package:zari/widgets/common_widgets.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('마이페이지')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          Column(
            children: const [
              CircleAvatar(radius: 40, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 50, color: Colors.white)),
              SizedBox(height: 12),
              Text("User님", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("user@email.com", style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),
          buildFeatureCard(children: [
            buildListTile(icon: Icons.settings, color: Colors.grey, title: '계정 설정', onTap: () {}),
            buildListTile(icon: Icons.notifications, color: Colors.blue, title: '알림 설정', onTap: () {}),
            buildListTile(icon: Icons.headset_mic, color: Colors.green, title: '고객센터', onTap: () {}),
          ]),
          const SizedBox(height: 20),
          buildFeatureCard(children: [buildListTile(icon: Icons.logout, color: Colors.red, title: '로그아웃', onTap: () {})])
        ],
      ),
    );
  }
}