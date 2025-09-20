import 'package:flutter/material.dart';

Widget buildFeatureCard({required List<Widget> children}) {
  final List<Widget> itemsWithDividers = [];
  for (int i = 0; i < children.length; i++) {
    itemsWithDividers.add(children[i]);
    if (i < children.length - 1) {
      itemsWithDividers.add(const Divider(height: 1, thickness: 0.5, indent: 56, color: Color(0xFFE0E0E0)));
    }
  }
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Column(children: itemsWithDividers),
  );
}

Widget buildListTile({required IconData icon, required Color color, required String title, required VoidCallback onTap}) {
  return ListTile(
    leading: Container(
      width: 32, height: 32,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
    title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    onTap: onTap,
  );
}