import 'package:app/widgets/build_card.dart';
import 'package:flutter/material.dart';

class CommunityFormCard extends StatelessWidget {
  const CommunityFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BuildCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🗣️ Community Forum',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              2,
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFA9D6A5),
                      child: Icon(Icons.person, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Great tips on reducing plastic waste!',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Join Forum',
                  style: TextStyle(color: Color(0xFF008080)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
