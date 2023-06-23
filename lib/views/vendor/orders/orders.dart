import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../../resources/styles_manager.dart';
import 'orders_tab/orders_tab_export.dart';

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
      length: 4,
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
            Tab(child: Text('Approved')),
            Tab(child: Text('Unapproved Orders')),
            Tab(child: Text('Undelivered Orders')),
            Tab(child: Text('Delivered')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabBarController,
        children: const [
          ApprovedOrders(),
          UnApprovedOrders(),
          UnDeliveredOrders(),
          DeliveredOrders(),
        ],
      ),
    );
  }
}
