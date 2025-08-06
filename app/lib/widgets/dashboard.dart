import 'package:app/widgets/build_card.dart';
import 'package:app/widgets/progress_item.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return  BuildCard(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Sustainability Dashboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: 0.7,
                              strokeWidth: 12,
                              backgroundColor: const Color(0xFFE8F5E8),
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF6C9A8B),
                              ),
                            ),
                          ),
                          const Text(
                            '70%\nProgress',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        ProgressItem(label: 'Waste', value:  0.8, color:  const
                            Color
                      (0xFF6C9A8B),),
                        const SizedBox(height: 8),
                        ProgressItem(label: 'Energy', value:  0.6, color:  const
                            Color
                          (0xFFA9D6A5)),
                        const SizedBox(height: 8),
                        ProgressItem(label: 'Travel', value:  0.4, color: const
                        Color
                          (0xFF008080)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
