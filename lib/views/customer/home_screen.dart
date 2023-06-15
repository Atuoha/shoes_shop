import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/models/product.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import '../../providers/category.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../components/single_product_grid.dart';
import '../widgets/banners.dart';
import '../widgets/cart_icon.dart';
import '../widgets/categories_section.dart';
import '../widgets/loading_widget.dart';
import '../widgets/search_box.dart';
import '../widgets/welcome_intro.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CategoryData categoryProvider = Provider.of<CategoryData>(context);
    Stream<QuerySnapshot> productStream =
        FirebaseFirestore.instance.collection('products').snapshots();

    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            right: 18,
            left: 18,
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Categories',
            style: getMediumStyle(
              color: Colors.black,
              fontSize: FontSize.s14,
            ),
          ),
        ),
        CategorySection(categoryProvider: categoryProvider),
        const SizedBox(height: 15),

        // Product StreamBuilder
        StreamBuilder<QuerySnapshot>(
          stream: productStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.hasError) {
              return Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        AssetManager.warningImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 5),
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

            return SizedBox(
              height: size.height / 3,
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.only(
                  top: 0,
                  right: 18,
                  left: 18,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data!.docs[index];

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
                    downLoadImgUrls: item['downLoadImgUrls'].cast<String>(),
                    uploadDate: item['uploadDate'].toDate(),
                  );

                  return snapshot.data!.docs.isNotEmpty
                      ? SingleProductGridItem(product: product, size: size)
                      : Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                Image.asset(
                                  AssetManager.addImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text('Product list is empty'),
                            ],
                          ),
                        );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
