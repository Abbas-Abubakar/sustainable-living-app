import 'package:app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/build_card.dart';
import 'package:app/models/eco_product.dart';
import 'package:app/providers/eco_product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Widget
class EcoProductsCard extends ConsumerWidget {
  const EcoProductsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(randomEcoProductsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '🛍️ Eco-Friendly Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full products page
                Navigator.pushReplacementNamed(context, AppRoutes.ecoProducts);
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Color(0xFF6C9A8B)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: productsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (products) => products.isEmpty
                ? const Center(child: Text('No eco-friendly products available'))
                : _buildProductList(products),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(List<EcoProduct> products) {
    return ListView.builder(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    product.imageUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF6C9A8B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}