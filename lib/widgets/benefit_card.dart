import 'package:flutter/material.dart';

class BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const BenefitCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFDCEAFF),
              child: Icon(icon, color: const Color(0xFF0B4FA8)),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
