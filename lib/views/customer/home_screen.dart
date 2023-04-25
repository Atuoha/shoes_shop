import 'package:flutter/material.dart';
import 'package:shoes_shop/resources/styles_manager.dart';

import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        right: 15,
        left: 18,
      ),
      child: Row(
        children: [
          Wrap(
            children: const [
              CircleAvatar(
                backgroundImage: AssetImage(AssetManager.profileImg),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Text('Hello Ujunwa 👋', style: getRegularStyle(color: Colors.black, fontSize:FontSize.s16),)
        ],
      ),
    );
  }
}
