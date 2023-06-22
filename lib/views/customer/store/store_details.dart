import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../../helpers/word_reverse.dart';
import '../../../models/product.dart';
import '../../../models/vendor.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../components/single_product_grid.dart';
import '../../widgets/item_row.dart';
import '../../widgets/k_cached_image.dart';
import '../../widgets/loading_widget.dart';
import '../relational_screens/product_details.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key, required this.vendor});

  final Vendor vendor;

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .orderBy('uploadDate', descending: true)
        .where('isApproved', isEqualTo: true)
        .where('vendorId', isEqualTo: widget.vendor.storeId)
        .snapshots();

    return Scaffold(
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
            KCachedImage(
              image: widget.vendor.storeImgUrl,
              height: size.height / 2.3,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vendor.storeName,
                    style: getBoldStyle(
                      color: Colors.black,
                      fontSize: FontSize.s30,
                    ),
                  ),
                  Text(
                    '${widget.vendor.city} ${widget.vendor.state} ${reversedWord(widget.vendor.country)}',
                    style: getRegularStyle(
                      color: Colors.black,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ItemRow(
                    value: widget.vendor.email,
                    title: 'Email: ',
                  ),
                  const SizedBox(height: 5),
                  ItemRow(
                    value: widget.vendor.phone,
                    title: 'Phone Number: ',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Products sold by ${widget.vendor.storeName}',
                    style: getRegularStyle(
                      color: greyFontColor,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Product StreamBuilder
                  StreamBuilder<QuerySnapshot>(
                    stream: productsStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  AssetManager.warningImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text('An error occurred!'),
                            ],
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: LoadingWidget(size: 30),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  AssetManager.addImage,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text('Product list is empty'),
                            ],
                          ),
                        );
                      }

                      return SizedBox(
                        height: size.height / 3,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          padding: const EdgeInsets.only(
                            top: 0,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!.docs[index];

                            Product product = Product.fromJson(item);

                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    product: product,
                                  ),
                                ),
                              ),
                              child: SingleProductGridItem(
                                product: product,
                                size: size,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
