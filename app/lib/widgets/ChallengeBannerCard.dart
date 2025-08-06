import 'package:app/widgets/build_card.dart';
import 'package:flutter/material.dart';

class ChallengeBannerCard extends StatelessWidget {
  const ChallengeBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  BuildCard(
      height: 120,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C9A8B), Color(0xFFA9D6A5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🏆 Join the Plastic-Free Week!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.3,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF6C9A8B),
                ),
                child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
