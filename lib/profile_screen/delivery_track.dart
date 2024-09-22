import 'package:flutter/material.dart';

class DeliveryTrackScreen extends StatelessWidget {
  const DeliveryTrackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Track'),
      ),
      body: Center(
        child: Text('Delivery Track Screen'),
      ),
    );
  }
}
