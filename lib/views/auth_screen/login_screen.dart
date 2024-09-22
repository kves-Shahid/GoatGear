import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';
import '../../consts/consts.dart';
import '../../consts/lists.dart';
import '../auth_screen/signup_screen.dart'; // Import the signup screen
import '../auth_screen/forget_password_screen.dart';
import '../home_screen/home_screen.dart';
import '../home_screen/main_home.dart'; // Import the forget password screen

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // User signed in successfully
      Get.to(() => const Home());

      // Fetch user data from Firestore if needed
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Example: Access user data
      if (userData.exists) {
        print('User Name: ${userData['name']}');
        print('User Email: ${userData['email']}');
      }

    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      Get.snackbar("Error", e.message ?? "An error occurred");
    } catch (e) {
      // Handle other errors
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log in to $appname"
                  .text
                  .fontFamily(bold)
                  .white
                  .size(15)
                  .make(),
              15.heightBox,
              Column(
                children: [
                  customTextField(emailHint, email, _emailController,
                      isPassword: false),
                  customTextField(passwordHint, password,
                      _passwordController, isPassword: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forget password screen
                        Get.to(() => ForgetPasswordScreen());
                      },
                      child: forgetPass.text.make(),
                    ),
                  ),
                  5.heightBox,
                  ourButton(
                    color: redColor,
                    title: login,
                    textColor: whiteColor,
                    onPress: _login,
                  ).box.width(context.screenWidth - 70).make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                    color: lightGolden,
                    title: signup,
                    textColor: whiteColor,
                    onPress: () {
                      Get.to(() => SignupScreen());
                    },
                  ).box.width(context.screenWidth - 70).make(),
                  10.heightBox,
                  loginWith.text.color(fontGrey).make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                          (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: lightGrey,
                          radius: 25,
                          child: Image.asset(
                            socialIconList[index],
                            width: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
