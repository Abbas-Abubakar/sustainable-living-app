import 'package:app/models/eco_product.dart';
import 'package:app/providers/eco_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EcoProductsPage extends ConsumerStatefulWidget {
  const EcoProductsPage({super.key});

  @override
  ConsumerState<EcoProductsPage> createState() => _EcoProductsPageState();
}

class _EcoProductsPageState extends ConsumerState<EcoProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productListProvider);
    final currentParams = ref.watch(productQueryParamsProvider);

    return Scaffold(
      backgroundColor: Color(0xFFF0F9F2),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_showSearch) _buildSearchBar(currentParams),
          categoriesAsync.when(
            data: (categories) => _buildFiltersSection(categories, currentParams),
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Error loading categories: $error'),
            ),
          ),
          Expanded(child: _buildProductsList(productsAsync)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: const Text('Eco-Friendly Products'),
      foregroundColor: Color(0xFF2E2E2E),
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(_showSearch ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) {
                _searchController.clear();
                _updateParams(search: null);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(ProductQueryParams params) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFC8E6C9),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (val) => _updateParams(search: val.isEmpty ? null : val),
      ),
    );
  }

  Widget _buildFiltersSection(List<String> categories, ProductQueryParams params) {
    final allCategories = ['All', ...categories];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: params.category ?? 'All',
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: allCategories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (val) {
                ref.read(productQueryParamsProvider.notifier).state = ref
                    .read(productQueryParamsProvider)
                    .copyWith(category: val == 'All' ? null : val);
              },
            ),
          ),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sort, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 4),
                  Text('Sort'),
                  Icon(params.descending ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Name')),
              const PopupMenuItem(value: 'price', child: Text('Price')),
              PopupMenuItem(
                value: 'toggle',
                child: Text(params.descending ? 'Ascending' : 'Descending'),
              ),
            ],
            onSelected: (value) {
              if (value == 'toggle') {
                _updateParams(descending: !params.descending);
              } else {
                _updateParams(sortBy: value);
              }
            },
          ),
        ],
      ),
    );
  }

  void _updateParams({
    String? search,
    String? category,
    String? sortBy,
    bool? descending,
  }) {
    final current = ref.read(productQueryParamsProvider);
    final updated = current.copyWith(
      searchQuery: search ?? current.searchQuery,
      category: category ?? current.category,
      sortBy: sortBy ?? current.sortBy,
      descending: descending ?? current.descending,
    );
    ref.read(productQueryParamsProvider.notifier).state = updated;
  }

  Widget _buildProductsList(AsyncValue<List<EcoProduct>> productsAsync) {
    return productsAsync.when(
      data: (products) => products.isEmpty
          ? const Center(child: Text('No products found'))
          : LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => _buildProductCard(products[index]),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(productListProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(EcoProduct product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
              child: product.imageUrl.isEmpty
                  ? Container(
                color: const Color(0xFFC8E6C9),
                child: const Icon(Icons.eco, size: 48, color: Color(0xFF4CAF50)),
              )
                  : null,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF388E3C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.eco, color: Colors.white, size: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
