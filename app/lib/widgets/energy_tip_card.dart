import 'package:app/widgets/build_card.dart';
import 'package:flutter/material.dart';

class EnergyTipCard extends StatefulWidget {
  const EnergyTipCard({super.key});

  @override
  State<EnergyTipCard> createState() => _EnergyTipCardState();
}

class _EnergyTipCardState extends State<EnergyTipCard> {
  @override
  Widget build(BuildContext context) {
    return BuildCard(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3CD),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lightbulb, color: Color(0xFFFF8C00)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '💡 Energy Tip',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Turn off devices at the plug to save power',
                    style: TextStyle(color: Colors.grey[600]),
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
