import 'package:flutter/material.dart';

import '../../resources/values_manager.dart';
import '../widgets/are_you_sure_dialog.dart';
import '../widgets/vendor_logout_ac.dart';
import '../widgets/vendor_welcome_intro.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              right: 18,
              left: 18,
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [VendorWelcomeIntro(), VendorLogoutAc()],
                ),
                SizedBox(height: AppSize.s10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
