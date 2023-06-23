import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../../constants/firebase_refs/collections.dart';
import '../../../models/app_data.dart';
import '../../components/build_vendor_dash_container.dart';
import '../../components/vendor_chart.dart';

class StoreDataAnalysis extends StatefulWidget {
  const StoreDataAnalysis({super.key});

  @override
  State<StoreDataAnalysis> createState() => _StoreDataAnalysisState();
}

class _StoreDataAnalysisState extends State<StoreDataAnalysis> {
  var vendorId = FirebaseAuth.instance.currentUser!.uid;
  var orders = 0;
  var availableFunds = 0.0;
  var products = 0;
  var undeliveredOrders = 0;
  var deliveredOrders = 0;
  var unApprovedOrders = 0;
  var approvedOrders = 0;
  var approvedProducts = 0;
  var unapprovedProducts = 0;

  var earnings = 0.0;

  Future<void> fetchData() async {
    // init because of refresh indicator
    setState(() {
      orders = 0;
      availableFunds = 0.0;
      products = 0;
      undeliveredOrders = 0;
      deliveredOrders = 0;
      approvedProducts = 0;
      unapprovedProducts = 0;
      earnings = 0.0;
      unApprovedOrders = 0;
      approvedOrders = 0;
    });

    // orders
    await FirebaseCollections.ordersCollection
        .where('vendorId', isEqualTo: vendorId)
        .get()
        .then(
          (QuerySnapshot data) => {
            //handling orders
            setState(() {
              orders = data.docs.length;
            }),
            //

            for (var doc in data.docs)
              {
                // handling checkouts
                if (!doc['isDelivered'])
                  {
                    setState(() {
                      availableFunds += doc['prodPrice'] * doc['prodQuantity'];
                    })
                  },
                //

                // handling delivered and undelivered orders
                if (doc['isDelivered'])
                  {
                    setState(() {
                      deliveredOrders += 1;
                    })
                  }
                else
                  {
                    setState(() {
                      undeliveredOrders += 1;
                    })
                  },
                //

                // handling unapproved and unApproved orders
                if (doc['isApproved'])
                  {
                    setState(() {
                      approvedOrders += 1;
                    })
                  }
                else
                  {
                    setState(() {
                      unApprovedOrders += 1;
                    })
                  }
                //
              }
          },
        );

    // products
    await FirebaseCollections.productsCollection
        .where('vendorId', isEqualTo: vendorId)
        .get()
        .then(
          (QuerySnapshot data) => {
            // handling products
            setState(() {
              products = data.docs.length;
            }),

            // handling approved and unapproved products
            for (var doc in data.docs)
              {
                if (doc['isApproved'])
                  {
                    setState(() {
                      approvedProducts += 1;
                    })
                  }
                else
                  {
                    setState(() {
                      unapprovedProducts += 1;
                    })
                  }
                //
              }
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
        title: 'Orders',
        number: orders,
        color: dashBlue,
        icon: Icons.shopping_cart_checkout,
      ),
      AppData(
        title: 'Unapproved \nOrders',
        number: unApprovedOrders,
        color: dashLime,
        icon: Icons.shopping_bag_rounded,
      ),
      AppData(
        title: 'Undelivered \nOrders',
        number: undeliveredOrders,
        color: dashOrange,
        icon: Icons.delivery_dining,
      ),
      AppData(
        title: 'Delivered \nOrders',
        number: deliveredOrders,
        color: dashPurple,
        icon: Icons.shopping_basket,
      ),
      AppData(
        title: 'Available Funds',
        number: availableFunds,
        color: dashGrey,
        icon: Icons.monetization_on,
        index: 1,
      ),
      AppData(
        title: 'Earnings',
        number: earnings,
        color: dashTeal,
        icon: Icons.monetization_on,
        index: 1,
      ),
      AppData(
        title: 'Products',
        number: products,
        color: dashRed,
        icon: Icons.shopping_bag,
      ),
      AppData(
        title: 'Approved \nProducts',
        number: approvedProducts,
        color: dashPink,
        icon: Icons.check_circle,
      ),
      AppData(
        title: 'Unapproved \nProducts',
        number: unapprovedProducts,
        color: dashBrown,
        icon: Icons.check_circle,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.chevron_left,
              color: primaryColor,
            ),
          );
        }),
      ),
      body: RefreshIndicator(
        color: accentColor,
        onRefresh: () => fetchData(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                VendorDataGraph(data: data),
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 2.3,
                  child: GridView.builder(
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      var item = data[index];

                      return BuildDashboardContainer(
                        title: item.title,
                        value: item.index == 1
                            ? '\$${item.number}'
                            : item.number.toString(),
                        color: item.color,
                        icon: item.icon,
                        isBtn: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
