import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/cart.dart';
import 'categories/categories.dart';
import 'profile/profile.dart';
import 'search/search.dart';
import 'store/store.dart';
import '../../constants/color.dart';
import 'cart/cart.dart';
import 'home_screen.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key, required this.index});
  final int index;

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
  void initState() {
    if (widget.index != 0) {
      setNewPage(widget.index);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);


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
              label:  Text(
               '${cartProvider.getCartQuantity}',
                style: const TextStyle(
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
