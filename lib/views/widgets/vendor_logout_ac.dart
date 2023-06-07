import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/route_manager.dart';
import 'are_you_sure_dialog.dart';

class VendorLogoutAc extends StatefulWidget {
  const VendorLogoutAc({Key? key}) : super(key: key);

  @override
  State<VendorLogoutAc> createState() => _VendorLogoutAcState();
}

class _VendorLogoutAcState extends State<VendorLogoutAc> {
  AuthController authController = AuthController();

  // return context
  get ctx => context;

  // logout
  logout() async {
    await authController.signOut();
    Navigator.of(ctx)
        .pushNamedAndRemoveUntil(RouteManager.accountType, (route) => false);
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
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => logoutDialog(),
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
    );
  }
}
