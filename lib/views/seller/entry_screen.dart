import 'package:flutter/material.dart';
import 'package:shoes_shop/controllers/auth_controller.dart';

import '../../resources/assets_manager.dart';
import '../../resources/styles_manager.dart';
import '../widgets/are_you_sure_dialog.dart';

class SellerEntryScreen extends StatelessWidget {
  const SellerEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController();

    // logout
    logout() async {
      await authController.signOut();
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

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetManager.successCheck),
          const SizedBox(height: 10),
          const Text('Hello there,'),
          const SizedBox(height: 10),
          Text(
            'Congratulations on creating your store with us! We kindly request your confirmation to finalize the setup and ensure the accuracy of your store details. \nPlease review and confirm the provided information at your earliest convenience.\nThank you for choosing our platform, and we look forward to your confirmation.\n Best regards',
            style: getRegularStyle(color: Colors.black),
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
