import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'categories/categories.dart';
import 'profile/profile.dart';
import 'search/search.dart';
import 'store/store.dart';
import '../../constants/color.dart';
import 'cart/cart.dart';
import 'home_screen.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainStateScreen();
}

class _CustomerMainStateScreen extends State<CustomerMainScreen> {
  var _pageIndex = 0;
  final List<Widget> _pages = const [
    CustomerHomeScreen(),
    CategoriesScreen(),
    StoreScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
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
        items: const [
          TabItem(icon: Icon(Icons.home, color: accentColor)),
          TabItem(icon: Icon(Icons.manage_search, color: accentColor)),
          TabItem(icon: Icon(Icons.storefront, color: accentColor)),
          TabItem(icon: Icon(Icons.search, color: accentColor)),
          TabItem(icon: Icon(Icons.shopping_cart, color: accentColor)),
          TabItem(icon: Icon(Icons.person, color: accentColor)),
        ],
        onTap: setNewPage,
      ),
      body: _pages[_pageIndex],
    );
  }
}
