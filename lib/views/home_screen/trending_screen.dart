import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/services/fake_store_service.dart';
import 'package:emart_app/components/views/product_details_screen.dart';
import 'package:emart_app/cart_screen/cart_provider.dart';
import 'components/product_details_screen.dart';

class TrendingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Products'),
        backgroundColor: Colors.red[400],
      ),
      body: FutureBuilder(
        future: FakeStoreService().fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching products: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No products available.'));
          } else {
            List<dynamic> products = snapshot.data as List<dynamic>;
            products.shuffle();
            List<dynamic> trendingProducts = products.take(4).toList();

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8),
                color: lightGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Trending Now',
                        style: TextStyle(
                          fontFamily: semibold,
                          fontSize: 20,
                          color: darkFontGrey,
                        ),
                      ),
                    ),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: trendingProducts.length,
                      itemBuilder: (context, index) {
                        final product = trendingProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(product['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['title'],
                                      style: TextStyle(
                                        fontFamily: semibold,
                                        color: darkFontGrey,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${product['price']}',
                                      style: TextStyle(
                                        fontFamily: bold,
                                        color: redColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(8)).make(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
