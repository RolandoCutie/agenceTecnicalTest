import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/forgot_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/products/presentation/pages/my_products_page.dart';
import 'features/products/presentation/pages/products_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4F46E5),
        brightness: Brightness.light,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      routes: {
        '/': (_) => const LoginPage(),
        '/login': (_) => const LoginPage(),
        '/forgot': (_) => const ForgotPage(),
        '/products': (_) => const ProductsPage(),
        '/profile': (_) => const ProfilePage(),
        '/my-products': (_) => const MyProductsPage(),
        '/settings': (_) => const SettingsPage(),
      },
      initialRoute: '/',
    );
  }
}
