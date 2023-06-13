import 'package:flutter/material.dart';
import 'create_prd_tab_screens/tabs_export.dart';

import '../../../constants/color.dart';
import '../main_screen.dart';

class VendorCreatePost extends StatefulWidget {
  const VendorCreatePost({Key? key}) : super(key: key);

  @override
  State<VendorCreatePost> createState() => _VendorCreatePostState();
}

class _VendorCreatePostState extends State<VendorCreatePost>
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
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const VendorMainScreen(index: 2),
              ),
            ),
            icon: const Icon(
              Icons.chevron_left,
              color: accentColor,
            ),
          );
        }),
        backgroundColor: primaryColor,
        bottom: TabBar(
          controller: _tabBarController,
          indicatorColor: accentColor,
          tabs: const [
            Tab(child: Text('General')),
            Tab(child: Text('Shipping')),
            Tab(child: Text('Attributes')),
            Tab(child: Text('Image Uploads')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabBarController,
        children: const [
          GeneralTab(),
          ShippingTab(),
          AttributesTab(),
          ImageUploadTab(),
        ],
      ),


    );
  }
}
