import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';
import '../../../../models/product.dart';
import '../../../../resources/assets_manager.dart';
import '../../../widgets/are_you_sure_dialog.dart';
import '../../../widgets/loading_widget.dart';
import '../single_product.dart';

class UnPublishedProducts extends StatefulWidget {
  const UnPublishedProducts({super.key});

  @override
  State<UnPublishedProducts> createState() => _UnPublishedProductsState();
}

class _UnPublishedProductsState extends State<UnPublishedProducts> {
  var userId = FirebaseAuth.instance.currentUser!.uid;

  // togglePublication
  Future<void> togglePublication(String prodId, bool isApproved) async {
    await FirebaseCollections.productsCollection.doc(prodId).update({
      'isApproved': !isApproved,
    });
  }

  // edit product
  void navigateToEditingProduct(Product product) {
    // Todo: Implement
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
      'check out this product ${product.productName}. We have ${product.quantity} available and we can deliver!',
      subject: 'We are selling it for ${product.price}',
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> productsStream = FirebaseCollections
        .productsCollection
        .where('vendorId', isEqualTo: userId)
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
                      onPressed: (context) => deleteProductDialog(product),
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
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
                      flex: 2,
                      onPressed: (context) => navigateToEditingProduct(product),
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) =>
                          togglePublication(product.prodId, product.isApproved),
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: product.isApproved
                          ? Icons.cancel
                          : Icons.check_circle,
                      label: product.isApproved ? 'Unpublish' : 'Publish',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: product.imgUrls[0],
                    imageBuilder: (context, imageProvider) => Hero(
                      tag: product.prodId,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: imageProvider,
                      ),
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
                  title: Text(product.productName),
                  subtitle: Text('\$${product.price}'),
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
