import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import '../../../constants/color.dart';
import '../../../models/product.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../widgets/item_row.dart';
import '../../widgets/loading_widget.dart';
import 'package:intl/intl.dart' as intl;

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  String selectedProductSize = '';
  int? selectedProductSizeIndex;
  bool isLoadingVendor = true;
  String vendorName = '';
  String vendorImage = '';
  String vendorAddress = '';

  // fetch vendorDetails
  Future<void> fetchVendorDetails() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(widget.product.vendorId)
        .get()
        .then((DocumentSnapshot data) {
      setState(() {
        vendorName = data['storeName'];
        vendorImage = data['storeImgUrl'];
        vendorAddress =
            'Located in ${data['city']} ${data['state']} ${data['country']}';
        isLoadingVendor = false;
      });
    });
  }

  // navigate to store
  void navigateToVendorStore() {
    // Todo: Navigate to vendor store
  }

  void setProductSize(String size, int index) {
    if (index == selectedProductSizeIndex) {
      setState(() {
        selectedProductSize = '';
        selectedProductSizeIndex = null;
      });
    } else {
      setState(() {
        selectedProductSize = size;
        selectedProductSizeIndex = index;
      });
    }
  }

// images in bottom sheet
  void showImageBottom() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) => SizedBox(
        height: 500,
        child: CarouselSlider.builder(
          itemCount: widget.product.downLoadImgUrls.length,
          itemBuilder: (context, index, i) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${index + 1}/${widget.product.downLoadImgUrls.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.product.downLoadImgUrls[index],
                    placeholder: (context, url) =>
                        Image.asset(AssetManager.placeholderImg),
                    errorWidget: (context, url, error) =>
                        Image.asset(AssetManager.placeholderImg),
                  ),
                )
              ],
            ),
          ),
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: 1.5,
            height: 500,
            autoPlay: true,
          ),
        ),
      ),
    );
  }

  // toggle isFav
  void toggleIsFav(bool status, String id) {
    final db = FirebaseFirestore.instance.collection('products').doc(id);
    setState(() {
      db.update({'isFav': !status});
    });
  }

  Animation<double>? _animation;
  AnimationController? _animationController;
  var isInit = true;

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

      //  fetching store details
      fetchVendorDetails();
    }
    setState(() {
      isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // similar products query
    final Stream<QuerySnapshot> similarProducts = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.product.category)
        .where('prodId', isNotEqualTo: widget.product.prodId)
        .snapshots();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Add to cart",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: Icons.shopping_cart_outlined,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onPress: () {
              _animationController!.reverse();
            },
          ),
          Bubble(
            title: "Check store",
            iconColor: Colors.white,
            bubbleColor: accentColor,
            icon: Icons.storefront,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onPress: () {
              // navigateToStore();
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
        actions: [
          GestureDetector(
            onTap: () =>
                toggleIsFav(widget.product.isFav, widget.product.prodId),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(
                widget.product.isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => showImageBottom(),
              child: Hero(
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
                    itemCount: widget.product.downLoadImgUrls.length,
                    itemBuilder: (context, index) => CachedNetworkImage(
                      imageUrl: widget.product.downLoadImgUrls[index],
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
                            title: 'Shoe Category: ',
                          ),
                          const SizedBox(height: 5),
                          ItemRow(
                            value: widget.product.brandName,
                            title: 'Brand: ',
                          ),
                          const SizedBox(height: 5),
                          ItemRow(
                            value: '\$${widget.product.billingAmount}',
                            title: 'Billing Amount: ',
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
                        child: GestureDetector(
                          onTap: () => setProductSize(
                              widget.product.sizesAvailable[index], index),
                          child: CircleAvatar(
                            backgroundColor: selectedProductSizeIndex == index
                                ? accentColor
                                : gridBg,
                            child: Text(
                              widget.product.sizesAvailable[index],
                              style: getRegularStyle(color: greyFontColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sold by:',
                    style: getRegularStyle(
                      color: greyFontColor,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // store
                  !isLoadingVendor
                      ? SizedBox(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: vendorImage,
                                imageBuilder: (context, imageProvider) => Hero(
                                  tag: widget.product.vendorId,
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                    AssetManager.placeholderImg,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                    AssetManager.placeholderImg,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vendorName,
                                    style: getMediumStyle(
                                      color: accentColor,
                                      fontSize: FontSize.s18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    vendorAddress,
                                    style: getRegularStyle(
                                      color: greyFontColor,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      side:
                                          const BorderSide(color: accentColor),
                                    ),
                                    onPressed: () => navigateToVendorStore(),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Icon(Icons.storefront,
                                            color: accentColor),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Visit store',
                                          style: getRegularStyle(
                                            color: accentColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const LoadingWidget(size: 20),

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
                  const SizedBox(height: 20),
                  Text(
                    'Similar Items You May Like',
                    style: getRegularStyle(
                      color: greyFontColor,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: size.height / 3.7,
                width: double.infinity,
                child: StreamBuilder<QuerySnapshot>(
                  stream: similarProducts,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: LoadingWidget(
                          size: 30,
                        ),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: [
                          Image.asset(
                            AssetManager.addImage,
                            width: 150,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'No similar products available!',
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          )
                        ],
                      );
                    }

                    return CarouselSlider.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index, i) {
                        final item = snapshot.data!.docs[index];

                        // modeling the item
                        Product product = Product(
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
                          downLoadImgUrls:
                              item['downLoadImgUrls'].cast<String>(),
                          uploadDate: item['uploadDate'].toDate(),
                          isApproved: item['isApproved'],
                          isFav: item['isFav'],
                        );
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  product: product,
                                ),
                              ),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          product.downLoadImgUrls[0],
                                          width: 173,
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () => toggleIsFav(
                                              product.isFav, product.prodId),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                accentColor.withOpacity(0.3),
                                            child: Icon(
                                              size: 15,
                                              product.isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: GestureDetector(
                                          onTap: () => null,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                accentColor.withOpacity(0.3),
                                            child: const Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product.productName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text('\$${product.price}')
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 0.5,
                        aspectRatio: 1.5,
                        height: size.height / 3.5,
                        autoPlay: true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
