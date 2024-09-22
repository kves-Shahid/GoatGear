// fake_store_products_screen.dart
import 'package:flutter/material.dart';

import '../services/fake_store_service.dart'; // Update the import path accordingly

class FakeStoreProductsScreen extends StatefulWidget {
  @override
  _FakeStoreProductsScreenState createState() => _FakeStoreProductsScreenState();
}

class _FakeStoreProductsScreenState extends State<FakeStoreProductsScreen> {
  final FakeStoreService apiService = FakeStoreService();
  List<dynamic> products = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await apiService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching products: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fake Store Products'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(errorMessage),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: Image.network(
            product['image'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product['title']),
          subtitle: Text('\$${product['price'].toString()}'),
        );
      },
    );
  }
}
