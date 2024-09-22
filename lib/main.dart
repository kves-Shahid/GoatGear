import 'package:emart_app/profile_screen/profile_screen.dart';
import 'package:emart_app/views/splah_screen/splash_screen.dart';
import 'package:emart_app/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cart_screen/cart_provider.dart';
import 'cart_screen/cart_screen.dart';
import 'firebase_options.dart';
import 'views/auth_screen/login_screen.dart';
import 'views/home_screen/main_home.dart';
// Import additional screens if needed
import 'cart_screen/cart_screen.dart'; // Example import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // Provide CartProvider
        // Add other providers here if needed
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Emart App',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          fontFamily: 'Regular',
        ),
        initialRoute: '/', // Set the initial route
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()), // Splash screen
          GetPage(name: '/login', page: () => LoginScreen()), // Login screen
          GetPage(name: '/profile', page: () => ProfileScreen()), // Profile screen
          GetPage(name: '/home', page: () => HomeScreen()), // Home screen
          // Add additional routes here
          GetPage(name: '/cart', page: () => CartScreen()), // Example route
        ],
        unknownRoute: GetPage(
          name: '/notfound',
          page: () => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: const Text('Page not found'),
            ),
          ),
        ),
      ),
    );
  }
}