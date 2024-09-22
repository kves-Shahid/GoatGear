import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emart_app/cart_screen/cart_screen.dart';
import 'package:emart_app/category_screen/category_screen.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:emart_app/profile_screen/profile_screen.dart';
import 'package:emart_app/views/home_screen/main_home.dart'; // Adjust import as per your project structure

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final List<Widget> navBody = [
       HomeScreen(),
      const CategoryScreen(),
       CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentNavIndex.value,
        children: navBody,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentNavIndex.value,
        selectedItemColor: redColor,
        selectedLabelStyle: const TextStyle(fontFamily: semibold),
        type: BottomNavigationBarType.fixed,
        backgroundColor: whiteColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: home),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: categories),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: cart),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: account),
        ],
        onTap: (value) {
          controller.currentNavIndex.value = value;
        },
      )),
    );
  }
}
