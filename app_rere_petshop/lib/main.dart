// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:app_rere_petshop/theme/app_theme.dart';
import 'package:app_rere_petshop/providers/product_provider.dart';
import 'package:app_rere_petshop/providers/cart_provider.dart';
import 'package:app_rere_petshop/providers/auth_provider.dart';
// import 'package:app_rere_petshop/pages/splash/splash_page.dart';
import 'package:app_rere_petshop/app/navigation.dart';  

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light, // Teks jam hitam di iOS
      statusBarIconBrightness: Brightness.dark, // Ikon hitam di Android
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..refreshCount()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..refreshProfile()),
      ],
      child: MaterialApp(
        title: 'ReRe Petshop',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigation(),
      ),
    );
  }
}
