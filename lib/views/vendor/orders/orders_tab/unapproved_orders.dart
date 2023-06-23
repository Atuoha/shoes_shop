import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoes_shop/constants/firebase_refs/collections.dart';
import 'package:shoes_shop/models/checked_out_item.dart';
import '../../../../constants/color.dart';
import '../../../../resources/assets_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/styles_manager.dart';
import '../../../components/single_vendor_checkout_list_tile.dart';
import '../../../widgets/are_you_sure_dialog.dart';
import '../../../widgets/loading_widget.dart';
import 'package:uuid/uuid.dart';

class UnApprovedOrders extends StatefulWidget {
  const UnApprovedOrders({super.key});

  @override
  State<UnApprovedOrders> createState() => _UnApprovedOrdersState();
}

class _UnApprovedOrdersState extends State<UnApprovedOrders> {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  Uuid uid = const Uuid();

  // toggle delivery dialog
  void togglePublishProductDialog(CheckedOutItem checkedOutItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          checkedOutItem.isApproved ? 'Cancel Approval' : 'Approve Order',
          style: getMediumStyle(
            color: Colors.black,
            fontSize: FontSize.s16,
          ),
        ),
        content: Text(
          'Are you sure you want to ${checkedOutItem.isApproved ? 'cancel approval of' : 'approve'} ${checkedOutItem.prodName}',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => toggleApproval(
                checkedOutItem.orderId, checkedOutItem.isApproved),
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

  // toggleDelivery
  Future<void> toggleApproval(String orderId, bool isApproved) async {
    await FirebaseCollections.ordersCollection.doc(orderId).update({
      'isApproved': !isApproved,
    }).whenComplete(
          () => Navigator.of(context).pop(),
    );
  }

  // delete product dialog
  void deleteProductDialog(CheckedOutItem checkOutItem) {
    areYouSureDialog(
      title: 'Delete Product',
      content: 'Are you sure you want to delete ${checkOutItem.prodName}',
      context: context,
      action: deleteProduct,
      isIdInvolved: true,
      id: checkOutItem.prodId,
    );
  }

  // delete product
  Future<void> deleteProduct(String prodId) async {
    await FirebaseCollections.ordersCollection.doc(prodId).delete();
  }

  // deliver all items dialog
  void approveAllProductsDialog() {
    areYouSureDialog(
      title: 'Cancel all delivery of products',
      content: 'Are you sure you want to approve of all orders?',
      context: context,
      action: approveAllApprovals,
    );
  }

  // cancel all deliveries
  Future<void> approveAllApprovals() async {
    await FirebaseCollections.ordersCollection
        .where('isApproved', isEqualTo: false)
        .get()
        .then(
          (QuerySnapshot data) {
        for (var doc in data.docs) {
          // cancel all deliveries
          FirebaseCollections.ordersCollection.doc(doc['orderId']).update({
            'isApproved': true,
          });
        }
      },
    ).whenComplete(
          () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> ordersStream = FirebaseCollections.ordersCollection
        .where('vendorId', isEqualTo: userId)
        .where('isApproved', isEqualTo: false)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersStream,
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
                  const Text('UnApproved Order list is empty'),
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

              CheckedOutItem checkedOutItem = CheckedOutItem.fromJson(item);

              return Slidable(
                key: const ValueKey(0),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      padding: const EdgeInsets.only(right: 3),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) =>
                          deleteProductDialog(checkedOutItem),
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) =>
                          togglePublishProductDialog(checkedOutItem),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      icon: checkedOutItem.isApproved
                          ? Icons.cancel
                          : Icons.check_circle,
                      label: checkedOutItem.isApproved
                          ? 'Cancel Approval'
                          : 'Approved',
                    ),
                  ],
                ),
                child: SingleVendorCheckOutListTile(
                  checkoutItem: checkedOutItem,
                ),
              );
            },
          );
        },
      ),
      bottomSheet: StreamBuilder<QuerySnapshot>(
        stream: ordersStream,
        builder: (context, snapshot) {
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
            return const SizedBox.shrink();
          }

          int checkedOutList = 0;
          double totalAmount = 0.0;

          checkedOutList = snapshot.data!.docs.length;
          for (var doc in snapshot.data!.docs) {
            totalAmount += doc['prodPrice'] * doc['prodQuantity'];
          }

          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: getRegularStyle(
                          color: greyFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: FontSize.s14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        style: getMediumStyle(
                          color: accentColor,
                          fontSize: FontSize.s25,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag_outlined,
                                  color: Colors.white),
                              const SizedBox(width: 15),
                              Text(
                                checkedOutList.toString(),
                                style: getRegularStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => approveAllProductsDialog(),
                        child: Container(
                          height: 50,
                          width: 120,
                          decoration: const BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Approval All Orders',
                              style: getMediumStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
