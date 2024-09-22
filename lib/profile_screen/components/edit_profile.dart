import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _pickImage() async {
    if (!kIsWeb) { // Check if not running on web
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else {
      // Handle image picking for web if necessary
      // You might need to implement a different method for web
      print("Image picking is not supported on the web.");
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile != null) {
      try {
        // Create a reference to the Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user!.uid}.jpg');

        // Upload the image
        await storageRef.putFile(_imageFile!);

        // Get the download URL
        return await storageRef.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return null; // Return null if no image file
  }

  Future<void> _updateProfile() async {
    try {
      String? imageUrl = await _uploadImage(); // Upload image and get URL

      // Update the user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'name': _nameController.text,
        if (imageUrl != null) 'profileImage': imageUrl,
      });

      Navigator.of(context).pop(); // Go back to the profile page
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          _nameController.text = snapshot['name'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
