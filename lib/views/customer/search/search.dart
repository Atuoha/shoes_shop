import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/product.dart';
import '../../../resources/assets_manager.dart';
import '../../components/single_product_grid.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_box.dart';
import '../relational_screens/product_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchText.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> searchProductsStream = FirebaseFirestore.instance
        .collection('products')
        .where('isApproved', isEqualTo: true)
        .where('productName', isGreaterThanOrEqualTo: searchText.text.trim())
        .where('productName', isLessThan: '${searchText.text.trim()}z')
        .snapshots();

    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBox(
            searchText: searchText,
          ),
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
            return searchText.text.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            AssetManager.ops,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Ops! No product matches search word'),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
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
                price: double.parse(item['price'].toString()),
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
