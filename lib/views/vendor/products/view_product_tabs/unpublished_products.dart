import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';
import '../../../../models/product.dart';
import '../../../../resources/assets_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/styles_manager.dart';
import '../../../components/single_vendor_product_list_tile.dart';
import '../../../widgets/are_you_sure_dialog.dart';
import '../../../widgets/loading_widget.dart';
import '../edit.dart';
import '../single_product.dart';

class UnPublishedProducts extends StatefulWidget {
  const UnPublishedProducts({super.key});

  @override
  State<UnPublishedProducts> createState() => _UnPublishedProductsState();
}

class _UnPublishedProductsState extends State<UnPublishedProducts> {
  var userId = FirebaseAuth.instance.currentUser!.uid;

  // toggle publish dialog
  void togglePublishProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          product.isApproved ? 'Unpublish Product' : 'Publish Product',
          style: getMediumStyle(
            color: Colors.black,
            fontSize: FontSize.s16,
          ),
        ),
        content: Text(
            'Are you sure you want to ${product.isApproved ? 'unpublish' : 'publish'} ${product.productName}'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () =>
                togglePublication(product.prodId, product.isApproved),
            child: const Text('Yes'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  // togglePublication
  Future<void> togglePublication(String prodId, bool isApproved) async {
    await FirebaseCollections.productsCollection.doc(prodId).update({
      'isApproved': !isApproved,
    }).whenComplete(
      () => Navigator.of(context).pop(),
    );
  }

  // edit product
  void navigateToEditingProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VendorEditProduct(product: product),
      ),
    );
  }

  // delete product dialog
  void deleteProductDialog(Product product) {
    areYouSureDialog(
      title: 'Delete Product',
      content: 'Are you sure you want to delete ${product.productName}',
      context: context,
      action: deleteProduct,
      isIdInvolved: true,
      id: product.prodId,
    );
  }

  // delete product
  Future<void> deleteProduct(String prodId) async {
    await FirebaseCollections.productsCollection.doc(prodId).delete();
  }

  void shareProduct(Product product) {
    Share.share(
      'Check out ${product.productName}. \nWe have ${product.quantity} available and we can deliver!',
      subject: 'We are selling it for ${product.price}',
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> productsStream = FirebaseCollections
        .productsCollection
        .where('vendorId', isEqualTo: userId)
        .where('isApproved', isEqualTo: false)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final item = snapshot.data!.docs[index];

              Product product = Product.fromJson(item);

              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VendorProductDetailsScreen(
                      product: product,
                    ),
                  ),
                ),
                child: Slidable(
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        padding: const EdgeInsets.only(right: 3),
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (context) => deleteProductDialog(product),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (context) => shareProduct(product),
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        padding: const EdgeInsets.only(right: 3),
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (context) =>
                            navigateToEditingProduct(product),
                        backgroundColor: const Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (context) =>
                            togglePublishProductDialog(product),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        icon: product.isApproved
                            ? Icons.cancel
                            : Icons.check_circle,
                        label: product.isApproved ? 'Unpublish' : 'Publish',
                      ),
                    ],
                  ),
                  child: SingleVendorProductListTile(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
