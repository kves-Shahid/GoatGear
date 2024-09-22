import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
import 'cart_provider.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<String> _promoCodes = [];
  final TextEditingController _promoCodeController = TextEditingController();
  String _promoCodeError = '';

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var cartItems = cartProvider.cartItems;
    var discount = cartProvider.discount;
    var totalAfterDiscount = cartProvider.totalAfterDiscount;
    var totalBeforeDiscount = cartProvider.totalBeforeDiscount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              cartProvider.clearCart();
            },
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['image'],
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '\$${item['price']} x ${item['quantity']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: () {
                        cartProvider.removeFromCart(item['id']);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promoCodeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Enter Promo Code',
                          hintText: 'PROMO2024',
                          errorText: _promoCodeError.isNotEmpty ? _promoCodeError : null,
                          errorStyle: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          String promoCode = _promoCodeController.text;
                          if (promoCode.isEmpty) {
                            _promoCodeError = 'Please enter a promo code.';
                          } else if (_promoCodes.contains(promoCode)) {
                            _promoCodeError = 'Promo code already applied.';
                          } else {
                            _promoCodes.add(promoCode);
                            cartProvider.applyPromoCodes(_promoCodes);
                            if (cartProvider.discount == 0.0) {
                              _promoCodeError = 'Promo code is expired or invalid.';
                            } else {
                              _promoCodeError = '';
                            }
                            _promoCodeController.clear();
                          }
                        });
                      },
                      child: Text('Apply'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red[400],
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Discounts and Offers:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildOfferTile(
                  title: '10% off on orders over \$50',
                  description: 'Apply this discount to get 10% off your order if it exceeds \$50.',
                  onTap: () {
                    setState(() {
                      cartProvider.applyPromoCodes(['OFFER10']);
                    });
                  },
                ),
                SizedBox(height: 8),
                _buildOfferTile(
                  title: 'Free shipping on orders over \$30',
                  description: 'Enjoy free shipping on orders over \$30. No code needed.',
                  onTap: () {
                    setState(() {
                      cartProvider.applyPromoCodes(['FREESHIP']);
                    });
                  },
                ),
                SizedBox(height: 16),
                _buildPriceRow(
                  label: 'Subtotal:',
                  amount: '\$${totalBeforeDiscount.toStringAsFixed(2)}',
                  fontSize: 18,
                ),
                SizedBox(height: 8),
                _buildPriceRow(
                  label: 'Discount:',
                  amount: '\$${discount.toStringAsFixed(2)}',
                  fontSize: 18,
                  color: Colors.green,
                ),
                SizedBox(height: 8),
                _buildPriceRow(
                  label: 'Total after discount:',
                  amount: '\$${totalAfterDiscount.toStringAsFixed(2)}',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      cartItems: cartItems,
                      totalAmount: totalAfterDiscount,
                    ),
                  ),
                );
              },
              child: Text(
                'Proceed to Payment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: whiteColor, backgroundColor: redColor,
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferTile({required String title, required String description, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String amount,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        Text(
          amount,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
        ),
      ],
    );
  }
}
