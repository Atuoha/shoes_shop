import 'package:flutter/material.dart';
import 'package:shoes_shop/controllers/route_manager.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import 'view_product_tabs/published_products.dart';
import 'view_product_tabs/unpublished_products.dart';
import '../../../constants/color.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  // navigate to create product
  void navigateToCreate() {
    Navigator.of(context).pushNamed(RouteManager.vendorCreatePost);
  }

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => navigateToCreate(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'All Products',
          style: getRegularStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        bottom: TabBar(
          controller: _tabBarController,
          indicatorColor: accentColor,
          tabs: const [
            Tab(child: Text('Published Products')),
            Tab(child: Text('Unpublished Products')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabBarController,
        children: const [
          PublishedProducts(),
          UnPublishedProducts(),
        ],
      ),
    );
  }
}
