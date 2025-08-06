import 'package:app/widgets/build_card.dart';
import 'package:flutter/material.dart';

class EcoProductsCard extends StatefulWidget {
  const EcoProductsCard({super.key});

  @override
  State<EcoProductsCard> createState() => _EcoProductsCardState();
}

class _EcoProductsCardState extends State<EcoProductsCard> {
  final products = [
    {
      'icon': Icons.shopping_bag,
      'name': 'Reusable Bags',
      'badge': 'Reusable',
    },
    {'icon': Icons.water_drop, 'name': 'Water Bottle', 'badge': 'BPA-Free'},
    {'icon': Icons.lightbulb, 'name': 'LED Bulbs', 'badge': 'Energy Star'},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🛍️ Eco-Friendly Products',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: 140,
                margin: EdgeInsets.only(right: index == products.length - 1 ? 0 : 12),
                child: BuildCard(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(
                          product['icon'] as IconData,
                          size: 30,
                          color: const Color(0xFF6C9A8B),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA9D6A5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            product['badge'] as String,
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
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
