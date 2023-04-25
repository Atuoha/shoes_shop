import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:shoes_shop/views/customers/categories/categories.dart';
import 'profile/profile.dart';
import 'search/search.dart';
import 'store/store.dart';
import '../../constants/color.dart';
import 'cart/cart.dart';
import 'home_screen.dart';

class CustomerMainScreen extends StatefulWidget {
  @override
  State<CustomerMainScreen> createState() => _CustomerMainStateScreen();
}

class _CustomerMainStateScreen extends State<CustomerMainScreen> {
  var _pageIndex = 0;
  final List<Widget> _pages = const [
    CustomerHomeScreen(),
    CategoriesScreen(),
    SearchScreen(),
    StoreScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: primaryColor,
          activeColor: Colors.white,
          items: const [
            TabItem(
                icon: Icon(
                  Icons.home,
                ),
                title: 'Home'),
            TabItem(icon: Icon(Icons.manage_search), title: 'Categories'),
            TabItem(icon: Icon(Icons.search), title: 'Search'),
            TabItem(icon: Icon(Icons.storefront), title: 'Store'),
            TabItem(icon: Icon(Icons.shopping_cart), title: 'Cart'),
            TabItem(icon: Icon(Icons.person), title: 'Profile'),
          ],
          onTap: (index) => setState(() {
            _pageIndex = index;
          }),
        ),
        body: _pages[_pageIndex]);
  }
}
