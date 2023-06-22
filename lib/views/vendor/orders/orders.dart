import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';
import 'package:shoes_shop/views/vendor/orders/orders_tab/delivered_orders.dart';

import '../../../constants/color.dart';
import '../../../resources/styles_manager.dart';
import 'orders_tab/undelivered_orders.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabBarController;

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Ordered Products',
          style: getRegularStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        bottom: TabBar(
          controller: _tabBarController,
          indicatorColor: accentColor,
          tabs: const [
            Tab(child: Text('Undelivered Products')),
            Tab(child: Text('Delivered Products')),

          ],
        ),
      ),
      body: TabBarView(
        controller: _tabBarController,
        children: const [
          UnDeliveredProducts(),
          DeliveredProducts(),
        ],
      ),
    );
  }
}
