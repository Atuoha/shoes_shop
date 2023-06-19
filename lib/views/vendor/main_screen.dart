import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:shoes_shop/views/vendor/profile/profile.dart';
import 'package:shoes_shop/views/vendor/dashboard.dart';
import 'package:shoes_shop/views/vendor/products/view_all.dart';
import '../../constants/color.dart';
import 'orders/orders.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key, required this.index});
  final int index;


  @override
  State<VendorMainScreen> createState() => _CustomerMainStateScreen();
}

class _CustomerMainStateScreen extends State<VendorMainScreen> {
  var _pageIndex = 0;

  final List<Widget> _pages = const [
    VendorDashboard(),
    OrdersScreen(),
    ProductScreen(),
    ProfileScreen()
  ];

  void setNewPage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    if (widget.index != 0) {
      setNewPage(widget.index);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: primaryColor,
        activeColor: Colors.white,
        style: TabStyle.reactCircle,
        initialActiveIndex: _pageIndex,
        items: [
          buildTabItem(Icons.home, 0),
          buildTabItem(Icons.shopping_bag, 1),
          buildTabItem(Icons.storefront, 2),
          buildTabItem(Icons.person, 3),
        ],
        onTap: setNewPage,
      ),
      body: _pages[_pageIndex],
    );
  }

  // custom tab item
  TabItem<dynamic> buildTabItem(IconData icon, int pageIndex) {
    return TabItem(
      icon: Icon(
        icon,
        color: accentColor,
        size: _pageIndex == pageIndex ? 40 : 25,
      ),
    );
  }
}
