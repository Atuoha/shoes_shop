import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import '../components/vendor_chart.dart';
import '../widgets/build_vendor_dash_container.dart';
import '../widgets/vendor_logout_ac.dart';
import '../widgets/vendor_welcome_intro.dart';
import '../../models/app_data.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orders = 0.0;
    var cashOuts = 0.0;
    var products = 0.0;

    // Todo: auto fill with data from firebase  -- in fact I think StreamBuilder for all the data will be more awesome
    List<AppData> data = [
      AppData('Orders', orders),
      AppData('Cash outs', cashOuts),
      AppData('Products', products),
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          right: 18,
          left: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VendorWelcomeIntro(),
                VendorLogoutAc(),
              ],
            ),
            const SizedBox(height: AppSize.s10),
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                // Todo: Implement each container using StreamBuilder
                BuildDashboardContainer(
                  title: 'Orders',
                  value: '$orders',
                  color: dashBlue,
                  icon: Icons.shopping_cart_checkout,
                  index: 1,
                ),
                BuildDashboardContainer(
                  title: 'Cash Outs',
                  value: '\$$cashOuts',
                  color: dashGrey,
                  icon: Icons.monetization_on,
                  index: 3,
                ),
                BuildDashboardContainer(
                  title: 'Products',
                  value: '$products',
                  color: dashRed,
                  icon: Icons.shopping_bag,
                  index: 2,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Your store analysis',
              style: getMediumStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            VendorDataGraph(data: data)
          ],
        ),
      ),
    );
  }
}
