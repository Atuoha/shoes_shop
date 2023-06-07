import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:shoes_shop/views/vendor/dashboard.dart';
import '../../constants/color.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _CustomerMainStateScreen();
}

class _CustomerMainStateScreen extends State<VendorMainScreen> {
  var _pageIndex = 0;

  final List<Widget> _pages = const [
    VendorDashboard(),
  ];

  void setNewPage(int index) {
    setState(() {
      _pageIndex = index;
    });
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
          buildTabItem(Icons.manage_search, 1),
          buildTabItem(Icons.storefront, 2),
          buildTabItem(Icons.search, 3),

          // cart
          TabItem(
            icon: Badge(
              backgroundColor: Colors.white,
              label: const Text(
                '1',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              child: Icon(
                Icons.shopping_cart,
                size: _pageIndex == 4 ? 40 : 25,
                color: accentColor,
              ),
            ),
          ),
          buildTabItem(Icons.person, 5),
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
