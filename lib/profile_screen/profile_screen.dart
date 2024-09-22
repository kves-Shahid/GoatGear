import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../cart_screen/cart_provider.dart';
import '../cart_screen/cart_screen.dart';
import '../consts/colors.dart';
import '../consts/images.dart';
import '../consts/lists.dart';
import '../consts/styles.dart';
import '../widgets_common/bg_widget.dart';
import 'components/details_card.dart';
import 'components/edit_profile.dart';
import 'chat_screen.dart';
import 'delivery_track.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _pickedImage;
  String? _imageUrl;

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      await _uploadImage();  // Call method to upload image
    } else {
      print('No image selected.');
    }
  }

  // Method to upload image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_pickedImage == null) {
      print('No image to upload.');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');

        print("Uploading image...");
        await storageRef.putFile(_pickedImage!);
        print("Image uploaded.");

        final downloadUrl = await storageRef.getDownloadURL();

        // Save the download URL to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'imageUrl': downloadUrl});

        setState(() {
          _imageUrl = downloadUrl;  // Update UI with the new image URL
        });
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var cartProvider = Provider.of<CartProvider>(context);
    var cartItemCount = cartProvider.cartItems.length;

    return bgWidget(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: const Icon(Icons.edit, color: whiteColor).onTap(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      }),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage, // Tap to select and upload a new image
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: _imageUrl != null
                              ? NetworkImage(_imageUrl!)
                              : AssetImage(imgProfile2) as ImageProvider,  // Fallback image if no URL
                        ),
                      ),
                      10.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (user != null) ...[
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return "Loading...".text.fontFamily(semibold).white.make();
                                  }

                                  if (snapshot.hasError) {
                                    return "Error: ${snapshot.error}".text.fontFamily(semibold).white.make();
                                  }

                                  if (snapshot.hasData && snapshot.data!.exists) {
                                    var userData = snapshot.data!;
                                    _imageUrl = userData['imageUrl'];  // Get image URL from Firestore

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        userData['name'].toString().text.fontFamily(semibold).white.make(),
                                        userData['email'].toString().text.fontFamily(semibold).white.make(),
                                      ],
                                    );
                                  }

                                  return "No Data".text.fontFamily(semibold).white.make();
                                },
                              ),
                            ] else
                              "Loading...".text.fontFamily(semibold).white.make(),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: whiteColor),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((_) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          });
                        },
                        child: "Logout".text.fontFamily(semibold).white.make(),
                      ),
                    ],
                  ),
                  20.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      detailsCard(
                        count: cartItemCount.toString(),
                        title: "In your cart",
                        width: context.screenWidth / 3.4,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CartScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // ListView for profile buttons
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider(color: lightGrey);
                    },
                    itemCount: profileButtonsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.asset(
                          profileButtonsIcon[index],
                          width: 22,
                        ),
                        title: profileButtonsList[index]
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        onTap: () {
                          if (profileButtonsList[index] == "Messages") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ChatScreen(),
                              ),
                            );
                          } else if (profileButtonsList[index] == "Track Delivery") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DeliveryTrackScreen(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ).box.white.rounded.margin(const EdgeInsets.all(12)).padding(const EdgeInsets.symmetric(horizontal: 16)).shadowSm.make(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
