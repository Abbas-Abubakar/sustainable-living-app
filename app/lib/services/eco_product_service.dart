import 'package:app/models/eco_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EcoProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<EcoProduct>> fetchProducts({
    String? searchQuery,
    String? categoryFilter,
    String sortBy = 'name',
    bool descending = false,
  }) async {
    try {
      Query query = _db.collection('eco_products');

      // Apply category filter first if provided
      if (categoryFilter != null && categoryFilter.isNotEmpty) {
        query = query.where('category', isEqualTo: categoryFilter);
      }

      // Add ordering - this might require a composite index
      query = query.orderBy(sortBy, descending: descending);

      print('Executing Firestore query...');
      final snapshot = await query.get();
      print('Query completed. Found ${snapshot.docs.length} documents');

      List<EcoProduct> products = snapshot.docs
          .map((doc) {
        try {
          return EcoProduct.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        } catch (e) {
          print('Error parsing document ${doc.id}: $e');
          return null;
        }
      })
          .where((product) => product != null)
          .cast<EcoProduct>()
          .toList();

      // Apply search filter client-side
      if (searchQuery != null && searchQuery.isNotEmpty) {
        products = products.where((product) =>
            product.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      }

      return products;
    } catch (e) {
      print('Error in fetchProducts: $e');
      rethrow;
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      print('Fetching categories...');
      final snapshot = await _db.collection('eco_products').get();
      print('Categories query completed. Found ${snapshot.docs.length} documents');

      // Extract unique categories
      final categories = snapshot.docs
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['category'] as String?;
      })
          .where((category) => category != null)
          .cast<String>()
          .toSet()
          .toList();

      print('Found categories: $categories');
      return categories;
    } catch (e) {
      print('Error in fetchCategories: $e');
      rethrow;
    }
  }

  // Alternative method without ordering to test basic connectivity
  Future<List<EcoProduct>> fetchProductsSimple() async {
    try {
      print('Executing simple query without ordering...');
      final snapshot = await _db.collection('eco_products').limit(10).get();
      print('Simple query completed. Found ${snapshot.docs.length} documents');

      return snapshot.docs
          .map((doc) => EcoProduct.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error in fetchProductsSimple: $e');
      rethrow;
    }
  }
}