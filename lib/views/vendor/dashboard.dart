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
  var availableFunds = 0.0;
  var products = 0;

  Future<void> fetchData() async {
    // init because of refresh indicator
    setState(() {
      orders = 0;
      availableFunds = 0.0;
      products = 0;
    });

    // orders
    await FirebaseCollections.ordersCollection
        .where('vendorId', isEqualTo: vendorId)
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
    await FirebaseCollections.productsCollection
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
      AppData(
        title: 'All Orders',
        number: orders,
        color: dashBlue,
        icon: Icons.shopping_cart_checkout,
        index: 1,
      ),
      AppData(
        title: 'Available Funds',
        number: availableFunds,
        color: dashGrey,
        icon: Icons.monetization_on,
        index: 3,
      ),
      AppData(
        title: 'Products',
        number: products,
        color: dashRed,
        icon: Icons.shopping_bag,
        index: 2,
      ),
    ];

    return Scaffold(
      body: RefreshIndicator(
        color: accentColor,
        onRefresh: () => fetchData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
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
                  child: ListView.builder(
                    itemCount: data.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    // crossAxisCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var item = data[index];

                      return BuildDashboardContainer(
                        title: item.title,
                        value: item.index == 3
                            ? '\$${item.number}'
                            : item.number.toString(),
                        color: item.color,
                        icon: item.icon,
                        index: item.index,
                      );
                    },
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
        ),
      ),
    );
  }
}
