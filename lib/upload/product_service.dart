import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(String name, String description, double price, String category, String imageUrl) async {
    try {
      await _productsCollection.add({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Product added with image URL to Firestore!');
    } catch (e) {
      print('Failed to add product: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _productsCollection.where('category', isEqualTo: category).get();
      List<Map<String, dynamic>> products = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      return products;
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }
}
