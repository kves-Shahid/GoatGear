import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:emart_app/widgets_common/custom_textfield.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  void _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Reset Email Sent", "Password reset email has been sent to $email");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed to send reset email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "Forget Password".text.color(fontGrey).bold.size(20).make(),
              20.heightBox,
              customTextField(emailHint, email, _emailController, isPassword: false),
              10.heightBox,
              ourButton(
                color: redColor,
                title: "Send Reset Email",
                textColor: whiteColor,
                onPress: () {
                  _resetPassword(_emailController.text.trim());
                },
              ).box.width(context.screenWidth - 70).make(),
              10.heightBox,
              TextButton(
                onPressed: () {
                  Get.back(); // Navigate back to login screen
                },
                child: "Back to Login".text.color(redColor).make(),
              ),
            ],
          ).p(16),
        ),
      ),
    );
  }
}
