import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import 'package:shoes_shop/views/widgets/are_you_sure_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/color.dart';
import '../../../controllers/route_manager.dart';
import '../../../helpers/word_reverse.dart';
import '../../../models/vendor.dart';
import '../../../resources/font_manager.dart';
import '../../widgets/k_cached_image.dart';
import '../../widgets/k_tile.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  Vendor vendor = Vendor.initial();
  var auth = FirebaseAuth.instance;

  var orders = 0;
  var availableFunds = 0.0;
  var products = 0;
  var earnings = 0.0;

  Future<void> fetchData() async {
    // init because of refresh indicator
    setState(() {
      orders = 0;
      availableFunds = 0.0;
      products = 0;
      earnings = 0.0;
    });

    // orders
    FirebaseCollections.ordersCollection
        .where('vendorId', isEqualTo: userId)
        .get()
        .then(
          (QuerySnapshot data) => {
            setState(() {
              orders = data.docs.length;
            }),

            // checkouts
            for (var doc in data.docs)
              {
                if (!doc['isDelivered'])
                  {
                    setState(() {
                      availableFunds += doc['prodPrice'] * doc['prodQuantity'];
                    })
                  }
              }
          },
        );

    // products
    FirebaseCollections.productsCollection
        .where('vendorId', isEqualTo: userId)
        .get()
        .then(
          (QuerySnapshot data) => {
            setState(() {
              products = data.docs.length;
            }),
          },
        );
  }

  // fetch vendor details
  Future<void> fetchVendor() async {
    await FirebaseCollections.vendorsCollection
        .doc(userId)
        .get()
        .then((DocumentSnapshot doc) => {
              setState(() {
                vendor = Vendor.fromDoc(doc);
                earnings = Vendor.fromDoc(doc).balanceAvailable;
              })
            });
  }

  @override
  void initState() {
    super.initState();
    fetchVendor();
    fetchData();
  }

  // navigateToSettings
  void navigateToSettings() {
    // Todo implement this
  }

  // navigate to store analysis
  void navigateToStoreAnalysis() {
    Navigator.of(context).pushNamed(RouteManager.vendorDataAnalysis);
  }

  // edit profile
  void editProfile() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => const VendorEditProfile(),
          ),
        )
        .then(
          (value) => setState(
            () {},
          ),
        );
  }

  // cash out
  Future<void> cashOut() async {
    var id = const Uuid().v4();
    double totalAmount = 0.0;



    await FirebaseCollections.ordersCollection
        .where('isDelivered', isEqualTo: false)
        .get()
        .then((QuerySnapshot data) {
      for (var doc in data.docs) {
        // update totalAmount
        totalAmount += doc['prodPrice'] * doc['prodQuantity'];

        FirebaseCollections.ordersCollection.doc(doc['orderId']).update({
          'isDelivered': true,
        });
      }

      // updating vendor's balance
      FirebaseCollections.vendorsCollection
          .doc(userId)
          .get()
          .then((DocumentSnapshot data) {
        FirebaseCollections.vendorsCollection.doc(userId).update({
          'balanceAvailable': data['balanceAvailable'] + totalAmount,
        });
      });

       FirebaseCollections.cashOutCollection.doc(id).set({
        'id': id,
        'vendorId': userId,
        'amount': totalAmount,
        'status': false,
        'date': DateTime.now(),
      });

    });

    Future.delayed(const Duration(seconds: 1));
    fetchData();
    Navigator.of(cxt).pop();
  }

  // cash out dialog
  void cashOutDialog() {
    areYouSureDialog(
      title: 'Cash out your money',
      content: 'Are you sure you want to cash out your money?',
      context: context,
      action: cashOut,
    );
  }

  // get context
  get cxt => context;

  // logout dialog
  void logoutDialog() {
    areYouSureDialog(
      title: 'Logout Account',
      content: 'Are you sure you want to logout account',
      context: context,
      action: logout,
    );
  }

  // logout
  Future<void> logout() async {
    await auth.signOut();
    Navigator.of(cxt).pushNamed(RouteManager.accountType);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor, boxBg],
            begin: Alignment.topCenter,
            end: Alignment.center,
            stops: [1, 1],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            left: 18,
            right: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KCachedImage(
                image: vendor.storeImgUrl,
                isCircleAvatar: true,
                radius: 60,
              ),
              const SizedBox(height: 10),
              Text(
                vendor.storeName,
                style: getMediumStyle(
                  color: Colors.white,
                  fontSize: FontSize.s30,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    vendor.email,
                    style: getRegularStyle(
                      color: Colors.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${vendor.city} ${vendor.state} ${reversedWord(vendor.country)}',
                    style: getRegularStyle(
                      color: Colors.white,
                      fontSize: FontSize.s13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: FittedBox(
                      child: Text(
                          'Available Funds: \$${availableFunds.toStringAsFixed(2)}'),
                    ),
                    avatar: const Icon(Icons.monetization_on),
                    backgroundColor: Colors.white,
                  ),
                  Chip(
                    label: Text('Orders: $orders'),
                    avatar: const Icon(Icons.shopping_cart_checkout),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: size.height / 2,
                width: size.width / 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        KListTile(
                          title: 'Edit Profile',
                          icon: Icons.edit_note,
                          onTapHandler: editProfile,
                          showSubtitle: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(thickness: 1),
                        ),
                        KListTile(
                          title: 'App Settings',
                          icon: Icons.settings,
                          onTapHandler: navigateToSettings,
                          showSubtitle: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(thickness: 1),
                        ),
                        KListTile(
                          title: 'Store Data Analysis',
                          icon: Icons.insert_chart,
                          onTapHandler: navigateToStoreAnalysis,
                          showSubtitle: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(thickness: 1),
                        ),
                        KListTile(
                          title: 'Logout',
                          icon: Icons.logout,
                          onTapHandler: logoutDialog,
                          showSubtitle: false,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Earnings',
                    style: getRegularStyle(
                      color: greyFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${earnings.toStringAsFixed(2)}',
                    style: getMediumStyle(
                      color: accentColor,
                      fontSize: FontSize.s25,
                    ),
                  )
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                    ),
                    child: const Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.wallet,
                            color: Colors.white,
                          ),
                          SizedBox(width: 15),

                        ],
                      ),
                    ),
                  ),
              GestureDetector(
                    onTap: () => cashOutDialog(),
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cash out Now',
                          style: getMediumStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
