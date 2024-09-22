import 'package:emart_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets_common/bg_widget.dart';
import '../../consts/consts.dart';
import '../../consts/lists.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
  TextEditingController();

  void _signup() async {
    if (isCheck == true) {
      if (_passwordController.text == _retypePasswordController.text) {
        try {
          UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          // User registered successfully
          Get.snackbar("Success", "User registered successfully");

          // Add user data to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _nameController.text,
            'email': _emailController.text,
            // Add more fields as needed
          });

          // Navigate to profile screen or any other screen after signup
          Get.offAllNamed('/profile');

        } on FirebaseAuthException catch (e) {
          // Handle Firebase Authentication errors
          Get.snackbar("Error", e.message ?? "An error occurred");
        } catch (e) {
          // Handle other errors
          Get.snackbar("Error", e.toString());
        }
      } else {
        // Passwords do not match
        Get.snackbar("Error", "Passwords do not match");
      }
    } else {
      // Terms and conditions not accepted
      Get.snackbar("Error", "You must accept the terms and conditions");
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
              "Sign up to $appname"
                  .text
                  .fontFamily(bold)
                  .white
                  .size(15)
                  .make(),
              15.heightBox,
              Column(
                children: [
                  customTextField(
                      nameHint, name, _nameController, isPassword: false),
                  customTextField(
                      emailHint, email, _emailController, isPassword: false),
                  customTextField(
                      passwordHint, password, _passwordController, isPassword: true),
                  customTextField(retypePassword, password,
                      _retypePasswordController, isPassword: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Implement your forget password functionality
                      },
                      child: forgetPass.text.make(),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: redColor,
                        value: isCheck,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        },
                      ),
                      10.widthBox,
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "I agree to the",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                ),
                              ),
                              TextSpan(
                                text: " $termsAndCond",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                ),
                              ),
                              TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                ),
                              ),
                              TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  5.heightBox,
                  ourButton(
                    color: isCheck == true ? redColor : lightGrey,
                    title: signup,
                    textColor: whiteColor,
                    onPress: _signup,
                  )
                      .box
                      .width(context.screenWidth - 50)
                      .make(),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      alreadyHaveAccount.text.color(fontGrey).make(),
                      login
                          .text
                          .color(redColor)
                          .make()
                          .onTap(() {
                        Get.back();
                      }),
                    ],
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
