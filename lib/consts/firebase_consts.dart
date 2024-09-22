import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

// Collections
const usersCollection = "users";
const productsCollection = "products"; // Example collection for Adidas products

// Example function to add Adidas product to Firestore
Future<void> addProductToFirestore(Map<String, dynamic> productData) async {
  try {
    await firestore.collection(productsCollection).add(productData);
    print("Product added to Firestore");
  } catch (e) {
    print("Error adding product to Firestore: $e");
    // Handle error
  }
}
