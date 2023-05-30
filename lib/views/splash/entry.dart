import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_shop/views/splash/splash.dart';
import '../../resources/assets_manager.dart';
import '../../controllers/route_manager.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    // var model = Navigator.of(context);
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    //
    // bool firstRun = preferences.getBool('isFirstRun') ?? true;
    //
    // if (firstRun) {
    //   model.push(MaterialPageRoute(builder: (context) => const SplashScreen()));
    //   preferences.setBool('isFirstRun', false);
    // }

    Timer(const Duration(seconds: 3), () {
       Navigator.of(context).pushNamed(RouteManager.splashScreen);
     });


    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AssetManager.logoTransparent,width:150),
      ),
    );
  }
}
