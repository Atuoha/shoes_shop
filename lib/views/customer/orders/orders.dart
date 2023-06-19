import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/color.dart';
import '../../../providers/order.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../components/single_order_item.dart';
import '../../vendor/main_screen.dart';
import '../main_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context, listen: false);

    void orderNow() {
      orderData.clearOrder();
      Navigator.of(context).pushNamed('');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Orders',
        ),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.chevron_left, color: iconColor),
            );
          },
        ),
      ),
      body: orderData.orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetManager.empty),
                  const SizedBox(height: 20),
                  const Text('Ops! Order is empty'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const CustomerMainScreen(index: 0),
                      ),
                    ),
                    child: const Text('Start shopping'),
                  )
                ],
              ),
            )
          : Consumer<OrderProvider>(
              builder: (_, orders, o) => Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: orders.orders.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleOrderItem(
                          id: orders.orders[index].id,
                          totalAmount: orders.orders[index].totalAmount,
                          date: orders.orders[index].orderDate,
                          orders: orders.orders[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomSheet: orderData.orders.isNotEmpty
          ? Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price',
                          style: getRegularStyle(
                            color: greyFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: FontSize.s14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '\$${orderData.getTotal.toStringAsFixed(2)}',
                          style: getMediumStyle(
                            color: accentColor,
                            fontSize: FontSize.s25,
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 80,
                          decoration:  BoxDecoration(
                            color: accentColor.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(Icons.shopping_bag_outlined,
                                    color: Colors.white),
                                const SizedBox(width: 15),
                                Text(
                                  orderData.orders.length.toString(),
                                  style: getRegularStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => orderNow(),
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: const BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Buy Now',
                                style: getMediumStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
