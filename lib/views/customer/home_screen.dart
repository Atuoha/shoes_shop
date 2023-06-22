import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/models/product.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import 'package:shoes_shop/views/customer/relational_screens/product_details.dart';
import '../../constants/firebase_refs/collections.dart';
import '../../providers/category.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../components/categories_section.dart';
import '../components/single_product_grid.dart';
import '../widgets/banners.dart';
import '../widgets/cart_icon.dart';
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
  void initState() {
    super.initState();

    searchText.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryData categoryProvider = Provider.of<CategoryData>(context);

    Size size = MediaQuery.sizeOf(context);

    Stream<QuerySnapshot> fetchProducts() {
      CollectionReference productCollection =
          FirebaseCollections.productsCollection;

      if (searchText.text.isNotEmpty) {
        if (categoryProvider.currentCategory.isNotEmpty) {
          return productCollection
              .orderBy('productName', descending: true)
              .where('isApproved', isEqualTo: true)
              .where('productName',
                  isGreaterThanOrEqualTo: searchText.text.trim())
              .where('productName', isLessThan: '${searchText.text.trim()}z')
              .snapshots();


        } else {
          return productCollection
              .orderBy('productName', descending: true)
              .where('isApproved', isEqualTo: true)
              .where('productName',
                  isGreaterThanOrEqualTo: searchText.text.trim())
              .where('productName', isLessThan: '${searchText.text.trim()}z')
              .where('category', isEqualTo: categoryProvider.currentCategory)
              .snapshots();
        }
      } else {
        if (categoryProvider.currentCategory.isNotEmpty) {
          return productCollection
              .orderBy('uploadDate', descending: true)
              .where('isApproved', isEqualTo: true)
              .where('category', isEqualTo: categoryProvider.currentCategory)
              .snapshots();
        } else {
          return productCollection
              .orderBy('uploadDate', descending: true)
              .where('isApproved', isEqualTo: true)
              .snapshots();
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
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
          // const SizedBox(height: 15),

          // Product StreamBuilder
          StreamBuilder<QuerySnapshot>(
            stream: fetchProducts(),
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
                height: size.height / 2.8,
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
          )
        ],
      ),
    );
  }
}
