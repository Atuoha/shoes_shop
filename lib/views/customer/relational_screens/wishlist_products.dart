import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shoes_shop/views/customer/relational_screens/product_details.dart';

import '../../../constants/color.dart';
import '../../../models/product.dart';
import '../../../resources/assets_manager.dart';
import '../../components/single_product_grid.dart';
import '../../widgets/loading_widget.dart';

class WishListProducts extends StatefulWidget {
  const WishListProducts({super.key});

  @override
  State<WishListProducts> createState() => _WishListProductsState();
}

class _WishListProductsState extends State<WishListProducts> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> searchProductsStream = FirebaseFirestore.instance
        .collection('products')
        .where('isApproved', isEqualTo: true)
        .where('isFav', isEqualTo: true)
        .snapshots();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('WishList'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: searchProductsStream,
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
                      AssetManager.love,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Ops! Wish list is empty'),
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
                imgUrls: item['imgUrls'].cast<String>(),
                uploadDate: item['uploadDate'].toDate(),
                isApproved: item['isApproved'],
                isFav: item['isFav'],
              );

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
    );
  }
}
