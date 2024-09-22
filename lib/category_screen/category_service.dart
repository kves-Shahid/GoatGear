import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  final String _baseUrl = 'https://fakestoreapi.com';

  // Placeholder images for categories
  final Map<String, String> _categoryImages = {
    'electronics': 'https://via.placeholder.com/150?text=Electronics',
    'jewelery': 'https://via.placeholder.com/150?text=Jewelry',
    'men clothing': 'https://via.placeholder.com/150?text=Men+Clothing',
    'women clothing': 'https://via.placeholder.com/150?text=Women+Clothing',
  };

  // Fetch the list of categories
  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products/categories'));
      if (response.statusCode == 200) {
        List<String> categories = List<String>.from(json.decode(response.body));
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Fetch category image URL
  Future<String?> getCategoryImage(String category) async {
    return 'https://via.placeholder.com/150?text=Test'; // For testing
  }


  // Fetch products by category
  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products/category/$category'));
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(json.decode(response.body));
        return products;
      } else {
        throw Exception('Failed to load products for category: $category');
      }
    } catch (e) {
      print('Error fetching products for category $category: $e');
      return [];
    }
  }

  // Fetch product details by product ID
  Future<Map<String, dynamic>> getProductDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product details for ID: $id');
      }
    } catch (e) {
      print('Error fetching product details for ID $id: $e');
      return {};
    }
  }
}
