import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';
import 'package:shoes_shop/views/widgets/kcool_alert.dart';
import '../../../constants/color.dart';
import '../../../providers/order.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../components/single_order_item.dart';
import '../../widgets/are_you_sure_dialog.dart';
import '../main_screen.dart';
import '../../../models/customer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Customer customer = Customer.initial();
  bool profileIncomplete = false;
  bool isAddressEmpty = false;
  bool isPhoneNumberEmpty = false;

  Future<void> fetchCustomerDetails() async {
    FirebaseCollections.customersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot data) {
      setState(() {
        customer = Customer(
          customerId: data['customerId'],
          fullname: data['fullname'],
          image: data['image'],
          email: data['email'],
          phone: data['phone'],
          address: data['address'],
        );
      });

      if (data['phone'].toString().isEmpty ||
          data['address'].toString().isEmpty) {
        setState(() {
          profileIncomplete = true;
        });
      }

      if (data['phone'].toString().isEmpty) {
        setState(() {
          isPhoneNumberEmpty = true;
        });
      }

      if (data['address'].toString().isEmpty) {
        setState(() {
          isAddressEmpty = true;
        });
      }

      print(
          'THIS IS CUSTOMER: ${customer.fullname}, ${customer.email}, ${customer.phone}, ${customer.address}');
      print('PROFILE INCOMPLETE: $profileIncomplete');
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context, listen: false);

    // remove cart items
    void removeAllOrderItems() {
      orderData.clearOrder();
    }

    // remove all cart items dialog
    void removeAllOrderItemsDialog() {
      areYouSureDialog(
        title: 'Remove all cart items',
        content: 'Are you sure you want to remove all order items',
        context: context,
        action: removeAllOrderItems,
      );
    }

    // navigate to profile
    void navigateToProfile() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CustomerMainScreen(index: 5),
        ),
      );
    }

    // order now button
    void orderNow() {
      if (profileIncomplete) {
        kCoolAlert(
          message: isAddressEmpty && isPhoneNumberEmpty
              ? 'Your profile is complete! Update your address and phone number'
              : isPhoneNumberEmpty
                  ? 'Your profile is complete! Update your phone number'
                  : 'Your profile is complete! Update your address',
          context: context,
          alert: CoolAlertType.error,
          action: navigateToProfile,
          confirmBtnText: 'Update Profile',
        );
      }




      // orderData.clearOrder();
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
        actions: [
          orderData.orders.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () => removeAllOrderItemsDialog(),
                  child: const Icon(
                    Icons.delete_forever,
                    color: iconColor,
                    size: 30,
                  ),
                ),
          const SizedBox(width: 18),
        ],
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
                          decoration: BoxDecoration(
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
