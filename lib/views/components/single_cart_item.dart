import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/enums/quantity_operation.dart';
import '../../constants/color.dart';
import '../../constants/enums/yes_no.dart';
import '../../controllers/route_manager.dart';
import '../../models/cart.dart';
import '../../models/product.dart';
import '../../providers/cart.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../customer/relational_screens/product_details.dart';
import '../widgets/text_action.dart';

class SingleCartItem extends StatefulWidget {
  const SingleCartItem({
    Key? key,
    required this.item,
    required this.cartData,
  }) : super(key: key);

  final Cart item;
  final CartProvider cartData;

  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  Product product = Product.initial();

  Future<Product> fetchProduct() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.item.prodId)
        .get()
        .then((item) {
      product = Product(
        prodId: item['prodId'],
        vendorId: item['vendorId'],
        productName: item['productName'],
        price: item['price'],
        quantity: item['quantity'],
        category: item['category'],
        description: item['description'],
        scheduleDate: item['scheduleDate'].toDate(),
        isCharging: item['isCharging'],
        billingAmount: item['billingAmount'],
        brandName: item['brandName'],
        sizesAvailable: item['sizesAvailable'].cast<String>(),
        imgUrls: item['imgUrls'].cast<String>(),
        uploadDate: item['uploadDate'].toDate(),
        isApproved: item['isApproved'],
        isFav: item['isFav'],
      );
    });

    return product;
  }

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.item.prodId),
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          elevation: 3,
          title: Text(
            'Are you sure?',
            style: getMediumStyle(
              color: Colors.black,
              fontSize: FontSize.s18,
            ),
          ),
          content: Text(
            'Do you want to remove ${widget.item.prodName} from cart?',
            style: getRegularStyle(
              color: Colors.black,
              fontSize: FontSize.s14,
            ),
          ),
          actions: [
            textAction('Yes', YesNo.yes, context),
            textAction('No', YesNo.no, context),
          ],
        ),
      ),
      onDismissed: (direction) =>
          widget.cartData.removeFromCart(widget.item.prodId),
      direction: DismissDirection.endToStart,
      background: Container(
        height: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: product,
            ),
          ),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: widget.item.prodImg,
                imageBuilder: (context, imageProvider) => Hero(
                  tag: product.prodId,
                  child: CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                ),
                placeholder: (context, url) => const CircleAvatar(
                  backgroundImage: AssetImage(
                    AssetManager.placeholderImg,
                  ),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  backgroundImage: AssetImage(
                    AssetManager.placeholderImg,
                  ),
                ),
              ),
              title: Text(widget.item.prodName),
              subtitle: Row(
                children: [
                  Text(
                    '\$${widget.item.price}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getMediumStyle(color: accentColor),
                  ),
                  const SizedBox(width: 5),
                  Text('Quantity: ${widget.item.quantity}')
                ],
              ),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => {
                      widget.item.quantity > 1
                          ? widget.cartData.toggleQuantity(
                              QuantityOperation.decrement,
                              widget.item.prodId,
                            )
                          : null
                    },
                    child: Text(
                      '-',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: widget.item.quantity == 1
                            ? Colors.grey
                            : primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => {
                      widget.cartData.toggleQuantity(
                        QuantityOperation.increment,
                        widget.item.prodId,
                      )
                    },
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
