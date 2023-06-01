import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_shop/controllers/route_manager.dart';
import 'package:shoes_shop/resources/theme_manager.dart';
import 'package:shoes_shop/views/splash/entry.dart';

import 'constants/color.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'helpers/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isAppPreviouslyRun = await checkIfAppPreviouslyRun();
  bool isCustomer = await checkAccountType();
  runApp(MyApp(
    isAppPreviouslyRun: isAppPreviouslyRun,
    isCustomer: isCustomer,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.isAppPreviouslyRun = false,
    this.isCustomer = true,
  });

  final bool isAppPreviouslyRun;
  final bool isCustomer;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: accentColor,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      title: 'Shoe\'s Store',
      home: EntryScreen(
        isAppPreviouslyRun: isAppPreviouslyRun,
        isCustomer: isCustomer,
      ),
      routes: routes,
    );
  }
}
