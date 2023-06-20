import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/controllers/auth_controller.dart';

import '../../constants/color.dart';
import '../../constants/firebase_refs/collections.dart';
import '../../controllers/route_manager.dart';
import '../../models/vendor.dart';
import '../../resources/assets_manager.dart';
import '../../resources/styles_manager.dart';
import '../widgets/are_you_sure_dialog.dart';
import 'package:confetti/confetti.dart';

import '../widgets/loading_widget.dart';
import 'main_screen.dart';

class VendorEntryScreen extends StatefulWidget {
  const VendorEntryScreen({Key? key}) : super(key: key);

  @override
  State<VendorEntryScreen> createState() => _VendorEntryScreenState();
}

class _VendorEntryScreenState extends State<VendorEntryScreen> {
  final ConfettiController confettiController = ConfettiController();
  AuthController authController = AuthController();
  final userId = FirebaseAuth.instance.currentUser!.uid;

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
    final Stream<DocumentSnapshot> query = FirebaseCollections.vendorsCollection
        .doc(userId)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: query,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget(size: 50));
          }

          Vendor vendor =
              Vendor.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          if (vendor.isApproved) {
            // account is approved
            return const VendorMainScreen(index:0);
          }

          return Column(
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
                ),
              ),
              Image.asset(AssetManager.successCheck),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: vendor.storeImgUrl,
                  placeholder: (context, url) =>
                      Image.asset(AssetManager.emptyImg),
                  errorWidget: (context, url, error) =>
                      Image.asset(AssetManager.emptyImg),
                  width: 50,
                ),
              ),
              const SizedBox(height: 10),
              Text('Hello ${vendor.storeName},'),
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
          );
        },
      ),
    );
  }
}
