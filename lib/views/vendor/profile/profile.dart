import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';

import '../../../constants/color.dart';
import '../../../models/vendor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  Vendor vendor = Vendor.initial();

  Future<void> fetchVendor() async {
    await FirebaseCollections.vendorsCollection
        .doc(userId)
        .get()
        .then((DocumentSnapshot doc) => {
              setState(() {
                vendor = Vendor.fromDoc(doc);
              })
            });
  }

  @override
  void initState() {
    super.initState();
    fetchVendor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.center,
            stops: [1, 1],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
