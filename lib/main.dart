import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_shop/resources/theme_manager.dart';
import 'package:shoes_shop/views/splash/entry.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      title: 'Shoe\'s Store',
      home: const EntryScreen(),
    );
  }
}
