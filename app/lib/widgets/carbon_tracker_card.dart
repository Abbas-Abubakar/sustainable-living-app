import 'package:app/providers/user_provider.dart';
import 'package:app/routes/app_routes.dart';

import '../providers/carbon_foot_print_provider.dart';
import 'package:app/widgets/build_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarbonTrackerCard extends ConsumerStatefulWidget {
  const CarbonTrackerCard({super.key});

  @override
  ConsumerState<CarbonTrackerCard> createState() => _CarbonTrackerCardState();
}

class _CarbonTrackerCardState extends ConsumerState<CarbonTrackerCard> {
  @override
  Widget build(BuildContext context) {
    final userId =  ref.watch(uidProvider);
    final totalFootprintAsync = userId != null
        ? ref.watch(totalCarbonFootprintProvider(userId))
        : const AsyncValue<double>.data(0.0);

    return BuildCard(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFA9D6A5).withValues(alpha: 0.02),
                  ),
                ),
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 0.65, // Optional: replace with actual % later
                    strokeWidth: 8,
                    backgroundColor: Color(0xFFE8F5E8),
                    valueColor: AlwaysStoppedAnimation(Color(0xFF6C9A8B)),
                  ),
                ),
                const Icon(Icons.eco, color: Color(0xFF2D5A4A), size: 30),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '🧭 Today\'s Carbon Usage',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  totalFootprintAsync.when(
                    data: (total) => Text(
                      '${total.toStringAsFixed(2)} kg CO₂',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D5A4A),
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => const Text('Error loading'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes
                          .carbonFootPrint);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008080),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Track Activity',
                      style: TextStyle(color: Colors.white),
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
