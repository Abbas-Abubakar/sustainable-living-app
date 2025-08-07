import 'package:app/models/eco_product.dart';
import 'package:app/services/eco_product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productServiceProvider = Provider<EcoProductService>((ref) => EcoProductService());

/// Query parameter state provider (used to avoid infinite rebuilds)
final productQueryParamsProvider = StateProvider<ProductQueryParams>((ref) {
  return ProductQueryParams(); // initial default values
});

/// Product list provider that watches the query params
final productListProvider = FutureProvider.autoDispose<List<EcoProduct>>((ref) async {
  final params = ref.watch(productQueryParamsProvider);
  final service = ref.read(productServiceProvider);

  try {
    final products = await service.fetchProducts(
      searchQuery: params.searchQuery,
      categoryFilter: (params.category == null || params.category == 'All') ? null : params.category,
      sortBy: params.sortBy,
      descending: params.descending,
    );
    print('ProductListProvider completed with ${products.length} products');
    return products;
  } catch (e) {
    print('ProductListProvider error: $e');
    rethrow;
  }
});

final randomEcoProductsProvider = FutureProvider.autoDispose<List<EcoProduct>>((ref) async {
  final service = ref.read(productServiceProvider);
  final allProducts = await service.fetchProducts();

  return allProducts
      .toList()
    ..shuffle()
    ..take(4)
    ..toList();
});

final categoriesProvider = FutureProvider<List<String>>((ref) {
  final service = ref.watch(productServiceProvider);
  return service.fetchCategories();
});

class ProductQueryParams {
  final String? searchQuery;
  final String? category;
  final String sortBy;
  final bool descending;

  ProductQueryParams({
    this.searchQuery,
    this.category,
    this.sortBy = 'name',
    this.descending = false,
  });

  ProductQueryParams copyWith({
    String? searchQuery,
    bool overrideSearch = false,
    String? category,
    bool overrideCategory = false,
    String? sortBy,
    bool? descending,
  }) {
    return ProductQueryParams(
      searchQuery: overrideSearch ? searchQuery : searchQuery ?? this.searchQuery,
      category: overrideCategory ? category : category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductQueryParams &&
              runtimeType == other.runtimeType &&
              searchQuery == other.searchQuery &&
              category == other.category &&
              sortBy == other.sortBy &&
              descending == other.descending;

  @override
  int get hashCode =>
      searchQuery.hashCode ^ category.hashCode ^ sortBy.hashCode ^ descending.hashCode;
}


extension ProductQueryParamsExtension on WidgetRef {
  void updateProductQueryParams({
    String? search,
    bool overrideSearch = false,
    String? category,
    bool overrideCategory = false,
    String? sortBy,
    bool? descending,
  }) {
    final current = read(productQueryParamsProvider);
    final updated = current.copyWith(
      searchQuery: search,
      overrideSearch: overrideSearch,
      category: category,
      overrideCategory: overrideCategory,
      sortBy: sortBy,
      descending: descending,
    );

    if (updated != current) {
      read(productQueryParamsProvider.notifier).state = updated;
    }
  }
}
