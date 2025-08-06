import 'package:app/widgets/build_card.dart';
import 'package:flutter/material.dart';

class WasteTrackerCard extends StatefulWidget {
  const WasteTrackerCard({super.key});


  @override
  State<WasteTrackerCard> createState() => _WasteTrackerCardState();
}

class _WasteTrackerCardState extends State<WasteTrackerCard> {
  final waste = [
    {'label': 'Plastic Saved', 'value': '2.4 kg', 'progress': 0.8},
    {'label': 'Composting', 'value': '1.2 kg', 'progress': 0.6},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📉 Waste Reduction',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: waste.map((item) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: waste.indexOf(item) == waste.length - 1 ? 0 : 8,
                ),
                child: BuildCard(
                  height: 110,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF6C9A8B),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['label'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['value'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D5A4A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: item['progress'] as double,
                          backgroundColor: const Color(0xFFE8F5E8),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF6C9A8B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
