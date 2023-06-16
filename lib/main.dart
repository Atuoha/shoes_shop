import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_shop/controllers/route_manager.dart';
import 'package:shoes_shop/providers/category.dart';
import 'package:shoes_shop/providers/product.dart';
import 'package:shoes_shop/resources/theme_manager.dart';
import 'package:shoes_shop/views/splash/entry.dart';
import 'constants/color.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helpers/shared_prefs.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductData(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryData(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: getLightTheme(),
            title: 'Shoe\'s Store',
            home: child,
            routes: routes,
          );
        },
        child: EntryScreen(
          isAppPreviouslyRun: isAppPreviouslyRun,
          isCustomer: isCustomer,
        ),
      ),
    );
  }
}
