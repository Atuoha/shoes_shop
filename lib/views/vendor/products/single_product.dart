import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import 'package:shoes_shop/views/widgets/are_you_sure_dialog.dart';
import '../../../constants/color.dart';
import '../../../constants/firebase_refs/collections.dart';
import '../../../models/product.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../widgets/item_row.dart';
import 'package:intl/intl.dart' as intl;

import 'edit.dart';

class VendorProductDetailsScreen extends StatefulWidget {
  const VendorProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<VendorProductDetailsScreen> createState() =>
      _VendorProductDetailsScreenState();
}

class _VendorProductDetailsScreenState extends State<VendorProductDetailsScreen>
    with TickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  var isInit = true;
  bool isPublished = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 260),
      );

      final curvedAnimation = CurvedAnimation(
        curve: Curves.easeInOut,
        parent: _animationController!,
      );
      _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    }
    setState(() {
      isInit = false;
      isPublished = widget.product.isApproved;
    });
    super.didChangeDependencies();
  }

  // get context
  get cxt => context;

  // delete Product
  Future<void> deleteProduct() async {
    await FirebaseCollections.productsCollection
        .doc(widget.product.prodId)
        .delete();
  }

  // delete product dialog
  void deleteProductDialog() {
    areYouSureDialog(
      title: 'Delete Product',
      content: 'Are you sure you want to delete ${widget.product.productName}',
      context: context,
      action: deleteProduct,
    );
  }

  // edit product
  void navigateToEditProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VendorEditProduct(product: widget.product),
      ),
    );
  }

  // toggle publication
  Future<void> toggleProductPublish() async {
    await FirebaseCollections.productsCollection
        .doc(widget.product.prodId)
        .update({
      'isApproved': !widget.product.isApproved,
    });

    setState(() {
      isPublished = !isPublished;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Delete Product",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: Icons.delete,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onPress: () {
              deleteProductDialog();
              _animationController!.reverse();
            },
          ),
          Bubble(
            title: isPublished ? "Unpublish Product" : ' Publish Product',
            iconColor: Colors.white,
            bubbleColor: isPublished ? primaryColor:Colors.green,
            icon: isPublished ? Icons.cancel : Icons.check_circle,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onPress: () {
              toggleProductPublish();
              _animationController!.reverse();
            },
          ),
          Bubble(
            title: "Edit Product",
            iconColor: Colors.white,
            bubbleColor: accentColor,
            icon: Icons.edit,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onPress: () {
              navigateToEditProduct();
              _animationController!.reverse();
            },
          ),
        ],
        animation: _animation!,
        onPress: () => _animationController!.isCompleted
            ? _animationController!.reverse()
            : _animationController!.forward(),
        iconColor: Colors.white,
        iconData: Icons.add,
        backGroundColor: accentColor,
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.chevron_left,
                color: primaryColor,
                size: 35,
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.product.prodId,
              child: Container(
                height: size.height / 2,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Swiper(
                  autoplay: true,
                  pagination: const SwiperPagination(
                    builder: SwiperPagination.dots,
                  ),
                  itemCount: widget.product.imgUrls.length,
                  itemBuilder: (context, index) => CachedNetworkImage(
                    imageUrl: widget.product.imgUrls[index],
                    imageBuilder: (context, imageProvider) => PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      maxScale: 100.0,
                      imageProvider: imageProvider,
                      // fit: BoxFit.cover,
                    ),
                    placeholder: (context, url) =>
                        Image.asset(AssetManager.placeholderImg),
                    errorWidget: (context, url, error) =>
                        Image.asset(AssetManager.placeholderImg),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: getBoldStyle(
                      color: Colors.black,
                      fontSize: FontSize.s30,
                    ),
                  ),
                  Text(
                    '\$${widget.product.price}',
                    style: getRegularStyle(
                      color: Colors.black,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemRow(
                            value: widget.product.category,
                            title: 'Shoe category: ',
                          ),
                          const SizedBox(height: 5),
                          ItemRow(
                            value: widget.product.brandName,
                            title: 'Brand: ',
                          ),
                          const SizedBox(height: 5),
                          ItemRow(
                            value: widget.product.isCharging ? 'Yes' : 'No',
                            title: 'Charging for shipping: ',
                          ),
                          const SizedBox(height: 5),
                          ItemRow(
                            value: '\$${widget.product.billingAmount}',
                            title: 'Shipping amount: ',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Scheduled:  ${intl.DateFormat.yMMMEd().format(widget.product.scheduleDate)}',
                            style: getLightStyle(color: Colors.black),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.product.quantity} available',
                            style: getRegularStyle(
                              color: greyFontColor,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          Text(
                            widget.product.quantity > 0
                                ? 'in stock'
                                : 'out of stock',
                            style: getRegularStyle(
                              color: widget.product.quantity > 0
                                  ? accentColor
                                  : greyFontColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: size.height / 13,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product.sizesAvailable.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          backgroundColor: gridBg,
                          child: Text(
                            widget.product.sizesAvailable[index],
                            style: getRegularStyle(color: greyFontColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ReadMoreText(
                    widget.product.description,
                    trimLines: 2,
                    colorClickableText: accentColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more ⌄',
                    trimExpandedText: 'Show less ^',
                    style: getRegularStyle(
                      color: greyFontColor,
                      fontSize: FontSize.s16,
                    ),
                    lessStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
