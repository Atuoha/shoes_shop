import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_shop/controllers/route_manager.dart';
import 'package:shoes_shop/resources/theme_manager.dart';
import 'package:shoes_shop/views/splash/entry.dart';

import 'constants/color.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: accentColor,
        statusBarBrightness: Brightness.dark
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      title: 'Shoe\'s Store',
      home: const EntryScreen(),
      routes: routes,
    );
  }
}
