import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shoes_shop/models/vendor.dart';
import 'package:shoes_shop/views/customer/store/store_details.dart';

import '../../../constants/firebase_refs/collections.dart';
import '../../../resources/assets_manager.dart';
import '../../components/single_store_grid.dart';
import '../../widgets/loading_widget.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  Stream<QuerySnapshot> vendorStream = FirebaseCollections.vendorsCollection
      .where('isApproved', isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Stores'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: vendorStream,
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
                  const SizedBox(width: 5),
                  const Text('Store list is empty'),
                ],
              ),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.only(top: 0, right: 18, left: 18),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final item = snapshot.data!.docs[index];

              Vendor vendor = Vendor(
                storeId: item['storeId'],
                storeName: item['storeName'],
                email: item['email'],
                phone: item['phone'],
                taxNumber: item['taxNumber'],
                storeNumber: item['storeNumber'],
                country: item['country'],
                state: item['state'],
                city: item['city'],
                storeImgUrl: item['storeImgUrl'],
                address: item['address'],
                authType: item['authType'],
              );

              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StoreDetailsScreen(
                      vendor: vendor,
                    ),
                  ),
                ),
                child: SingleStoreGridItem(
                  vendor: vendor,
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
