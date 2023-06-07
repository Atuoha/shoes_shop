import 'package:flutter/material.dart';
import 'package:shoes_shop/controllers/auth_controller.dart';

import '../../constants/color.dart';
import '../../controllers/route_manager.dart';
import '../../resources/assets_manager.dart';
import '../../resources/styles_manager.dart';
import '../widgets/are_you_sure_dialog.dart';
import 'package:confetti/confetti.dart';

class VendorEntryScreen extends StatefulWidget {
  const VendorEntryScreen({Key? key}) : super(key: key);

  @override
  State<VendorEntryScreen> createState() => _VendorEntryScreenState();
}

class _VendorEntryScreenState extends State<VendorEntryScreen> {
  final ConfettiController confettiController = ConfettiController();

  AuthController authController = AuthController();

  // return context
  get ctx => context;

  // logout
  logout() async {
    await authController.signOut();
    Navigator.of(ctx).pushNamed(RouteManager.accountType);
  }

  // logout dialog
  void logoutDialog() {
    areYouSureDialog(
      title: 'Sign out',
      content: 'Are you sure you want to sign out?',
      context: context,
      action: logout,
    );
  }

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }

  @override
  void dispose() {
    super.dispose();
    confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              colors: const [
                primaryColor,
                accentColor,
              ],
              numberOfParticles: 150,
              blastDirectionality: BlastDirectionality.explosive,
              gravity: 1,
              // blastDirection: pi,
            ),
          ),
          Image.asset(AssetManager.successCheck),
          const SizedBox(height: 10),
          const Text('Hello there,'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Congratulations on creating your store with us! Allow us some time so we can kindly confirm to finalize the setup and ensure the accuracy of your store details.\n\nBest regards!',
              style: getRegularStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => logoutDialog(),
            child: const Text('Sign out'),
          )
        ],
      ),
    );
  }
}
