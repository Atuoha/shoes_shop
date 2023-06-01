import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../widgets/banners.dart';
import '../widgets/cart_icon.dart';
import '../widgets/categories_section.dart';
import '../widgets/search_box.dart';
import '../widgets/welcome_intro.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    FirebaseAuth.instance.signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            right: 18,
            left: 18,
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WelcomeIntro(),
                  CartIcon(),
                ],
              ),
              const SizedBox(height: AppSize.s10),
              SearchBox(searchText: searchText),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s10),
        const BannerComponent(),
        const SizedBox(height: AppSize.s10),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Categories',
            style: getMediumStyle(
              color: Colors.black,
              fontSize: FontSize.s14,
            ),
          ),
        ),
        const CategorySection()
      ],
    );
  }
}
