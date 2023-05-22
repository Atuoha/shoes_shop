import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            right: 18,
            left: 18,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
        const CategorySection()
      ],
    );
  }
}
