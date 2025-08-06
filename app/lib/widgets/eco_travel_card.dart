import 'package:app/widgets/build_card.dart';
import 'package:flutter/material.dart';

class EcoTravelCard extends StatelessWidget {
  const EcoTravelCard({super.key});

  @override
  Widget build(BuildContext context) {
    final travel = [
      {'icon': Icons.directions_bike, 'name': 'Cycling'},
      {'icon': Icons.train, 'name': 'Public Transport'},
      {'icon': Icons.hotel, 'name': 'Green Hotels'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🚆 Eco-Travel',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: travel.length,
            itemBuilder: (context, index) {
              final item = travel[index];
              return Container(
                width: 120,
                margin: EdgeInsets.only(right: index == travel.length - 1 ? 0 : 12),
                child: BuildCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 30,
                        color: const Color(0xFF6C9A8B),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
