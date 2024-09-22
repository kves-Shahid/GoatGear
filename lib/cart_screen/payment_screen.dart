import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems; // List of cart items
  final double totalAmount; // Total amount after discount

  PaymentScreen({required this.cartItems, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['title']}: \$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Quantity: ${item['quantity']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Credit Card'),
              leading: Radio(
                value: 'Credit Card',
                groupValue: 'paymentMethod',
                onChanged: (value) {
                  // Handle payment method selection
                },
              ),
            ),
            ListTile(
              title: Text('PayPal'),
              leading: Radio(
                value: 'PayPal',
                groupValue: 'paymentMethod',
                onChanged: (value) {
                  // Handle payment method selection
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle payment process here
              },
              child: Text('Pay Now'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red[400],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
