import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';
import '../../constants/color.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import '../components/vendor_chart.dart';
import '../components/build_vendor_dash_container.dart';
import '../widgets/vendor_logout_ac.dart';
import '../widgets/vendor_welcome_intro.dart';
import '../../models/app_data.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({Key? key}) : super(key: key);

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  var vendorId = FirebaseAuth.instance.currentUser!.uid;
  var orders = 0;
  var cashOuts = 0.0;
  var products = 0;

  Future<void> fetchData() async {
    // orders
    FirebaseCollections.ordersCollection
        .where('vendorId', isEqualTo: vendorId)
        .get()
        .then(
          (QuerySnapshot data) => {
            setState(() {
              orders = data.docs.length;
            }),
            for (var doc in data.docs)
              {
                setState(() {
                  cashOuts += doc['prodPrice'];
                })
              }
          },
        );

    // products
    FirebaseCollections.productsCollection
        .where('vendorId', isEqualTo: vendorId)
        .get()
        .then(
          (QuerySnapshot data) => {
            setState(() {
              products = data.docs.length;
            }),
          },
        );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    List<AppData> data = [
      AppData('Orders', orders),
      AppData('Cash outs', cashOuts),
      AppData('Products', products),
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          right: 18,
          left: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VendorWelcomeIntro(),
                VendorLogoutAc(),
              ],
            ),
            const SizedBox(height: AppSize.s10),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6.5,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                // crossAxisCount: 3,
                scrollDirection: Axis.horizontal,
                children: [
                  // Todo: Implement each container using StreamBuilder
                  BuildDashboardContainer(
                    title: 'Orders',
                    value: '$orders',
                    color: dashBlue,
                    icon: Icons.shopping_cart_checkout,
                    index: 1,
                  ),
                  BuildDashboardContainer(
                    title: 'Cash Outs',
                    value: '\$$cashOuts',
                    color: dashGrey,
                    icon: Icons.monetization_on,
                    index: 3,
                  ),
                  BuildDashboardContainer(
                    title: 'Products',
                    value: '$products',
                    color: dashRed,
                    icon: Icons.shopping_bag,
                    index: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your store analysis',
              style: getMediumStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            VendorDataGraph(data: data)
          ],
        ),
      ),
    );
  }
}
