import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/providers/cart.dart';
import 'package:shoes_shop/views/customer/main_screen.dart';
import 'package:shoes_shop/views/widgets/are_you_sure_dialog.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/status.dart';
import '../../../controllers/route_manager.dart';
import '../../../providers/order.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../components/single_cart_item.dart';
import '../../widgets/msg_snackbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<CartProvider>(context);

    // remove cart items
    void removeAllCartItems() {
      cartData.clearCart();
    }

    // remove all cart items dialog
    void removeAllCartItemsDialog() {
      areYouSureDialog(
        title: 'Remove all cart items',
        content: 'Are you sure you want to remove all cart items',
        context: context,
        action: removeAllCartItems,
      );
    }

    // order now
    void orderNow() {
      if (cartData.getCartTotalAmount() > 0) {
        Provider.of<OrderProvider>(context, listen: false).addOrder(
          cartData.getCartTotalAmount(),
          cartData.getCartItems.values.toList(),
        );
        Provider.of<CartProvider>(context, listen: false).clearCart();
        Navigator.of(context).pushNamed(RouteManager.ordersScreen);
      } else {
        displaySnackBar(
          status: Status.error,
          message: 'Cart is empty!',
          context: context,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          if (cartData.isItemEmpty()) ...[
            const SizedBox.shrink()
          ] else ...[
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                RouteManager.ordersScreen,
              ),
              child: const Icon(
                Icons.shopping_cart_checkout,
                color: iconColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => removeAllCartItemsDialog(),
              child: const Icon(
                Icons.delete_forever,
                color: iconColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 18),
          ]
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: cartData.isItemEmpty()
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetManager.empty),
                    const SizedBox(height: 20),
                    const Text('Ops! Cart is empty'),
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
                      child: const Text('Continue shopping'),
                    )
                  ],
                ),
              )
            : ListView.builder(
                itemCount: cartData.getCartQuantity,
                itemBuilder: (context, index) {
                  var item = cartData.getCartItems.values.toList()[index];

                  return SingleCartItem(item: item, cartData: cartData);
                },
              ),
      ),
      bottomSheet: cartData.isItemEmpty()
          ? const SizedBox.shrink()
          : Container(
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
                          '\$${cartData.getCartTotalAmount().toStringAsFixed(2)}',
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
                                const Icon(
                                  Icons.shopping_cart_checkout,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  cartData.getCartQuantity.toString(),
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
                                'Order Now',
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
            ),
    );
  }
}
