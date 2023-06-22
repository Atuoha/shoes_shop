import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shoes_shop/constants/color.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import 'package:shoes_shop/views/customer/relational_screens/product_details.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../resources/assets_manager.dart';
import '../../components/single_product_grid.dart';
import '../../widgets/loading_widget.dart';

class ProductByCategoryScreen extends StatefulWidget {
  const ProductByCategoryScreen({super.key, required this.category});

  final Category category;

  @override
  State<ProductByCategoryScreen> createState() =>
      _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .orderBy('uploadDate', descending: true)
        .where('isApproved', isEqualTo: true)
        .where('category', isEqualTo: widget.category.title)
        .snapshots();

    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.chevron_left,
                color: accentColor,
                size: 35,
              ),
            );
          },
        ),
        actions: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: widget.category.imgUrl,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
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
              const SizedBox(width: 10),
              Text(
                widget.category.title,
                style: getMediumStyle(color: Colors.black),
              ),
              const SizedBox(width: 18),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: productStream,
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

            return MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
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
            );
          },
        ),
      ),
    );
  }
}
