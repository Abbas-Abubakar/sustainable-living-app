import 'package:app/widgets/build_card.dart';
import 'package:flutter/material.dart';

class CertificationsCard extends StatelessWidget {
  const CertificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final certs = [
      {'icon': Icons.star, 'name': 'Energy Star', 'desc': 'Energy efficient'},
      {'icon': Icons.verified, 'name': 'Organic', 'desc': 'Chemical-free'},
      {'icon': Icons.recycling, 'name': 'Recyclable', 'desc': 'Eco packaging'},
      {'icon': Icons.nature, 'name': 'Fair Trade', 'desc': 'Ethical sourcing'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '✅ Green Certifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: certs.length,
          itemBuilder: (context, index) {
            final cert = certs[index];
            return BuildCard(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(cert['icon'] as IconData, color: const Color(0xFF6C9A8B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cert['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            cert['desc'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
