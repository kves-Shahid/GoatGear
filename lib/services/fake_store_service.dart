import 'dart:convert';
import 'package:http/http.dart' as http;

class FakeStoreService {
  final String _baseUrl = 'https://fakestoreapi.com';

  // Fetch all products
  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch products by category
  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products for category $category');
    }
  }
}
