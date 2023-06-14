import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/constants/color.dart';
import 'package:shoes_shop/resources/assets_manager.dart';
import '../../../../constants/enums/status.dart';
import '../../../../controllers/product_controller.dart';
import '../../../../models/product.dart';
import '../../../../models/request_result.dart';
import '../../../../providers/product.dart';
import '../../../../resources/styles_manager.dart';
import '../../../widgets/kcool_alert.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/msg_snackbar.dart';
import 'package:path/path.dart' as path;

import 'package:uuid/uuid.dart';

import '../../main_screen.dart';

class ImageUploadTab extends StatefulWidget {
  const ImageUploadTab({Key? key}) : super(key: key);

  @override
  State<ImageUploadTab> createState() => _ImageUploadTabState();
}

class _ImageUploadTabState extends State<ImageUploadTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ImagePicker _picker = ImagePicker();
  final firebaseStorage = FirebaseStorage.instance;
  final uuid = const Uuid();
  final vendorId = FirebaseAuth.instance.currentUser!.uid;
  final ProductController _productController = ProductController();
  bool isLoading = false;
  bool uploadingImageStatus = false;
  bool doneUploadingImage = false;
  var currentImage = 0;
  List<XFile>? productImages = [];

  // get context
  get cxt => context;

  // loading fnc
  isLoadingFnc() async {
    setState(() {
      isLoading = true;
    });

    // navigate back to products screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            const VendorMainScreen(index: 2), // Todo: add index
      ),
    );
  }

  // called after an action is completed
  void completeAction() {
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final productProvider = Provider.of<ProductData>(context);

    // for selecting photo
    Future selectPhoto() async {
      List<XFile>? pickedImages;

      pickedImages = await _picker.pickMultiImage(
        maxWidth: 600,
        maxHeight: 600,
      );

      if (pickedImages == null) {
        return null;
      }

      if (pickedImages.length < 2) {
        displaySnackBar(
          message: 'Select more than one image',
          context: cxt,
          status: Status.error,
        );
        return null;
      }

      // assign the picked image to the profileImage
      setState(() {
        productImages = pickedImages;
      });
    }


    // show snackbar msg
    void showMsg() {
      displaySnackBar(
        status: Status.success,
        message: uploadingImageStatus
            ? 'Image is still trying to upload'
            : 'Image has fully uploading. Upload Product',
        context: context,
      );
    }

    void uploadImages() async {
      setState(() {
        uploadingImageStatus = true;
      });

      // upload images to firebase
      List<String> downLoadImgUrls = [];
      for (var img in productImages!) {
        try {
          var storageRef =
              firebaseStorage.ref('product-images/${path.basename(img.path)}');
          await storageRef.putFile(File(img.path)).whenComplete(() async {
            await storageRef.getDownloadURL().then((value) {
              downLoadImgUrls.add(value);
              setState(() {
                uploadingImageStatus = false;
              });
            });
          });
        } catch (e) {
          setState(() {
            uploadingImageStatus = false;
          });
          displaySnackBar(
            status: Status.error,
            message: 'Error uploading product images ',
            context: cxt,
          );
        }
      }

      // persist using provider
      productProvider.updateProductImg(
        downLoadImgUrls: downLoadImgUrls,
      );
    }

    // submit product
    Future<void> submitProduct() async {
      print(productProvider.productData);
      var id = uuid.v4();

      RequestResult? result = await _productController.createProduct(
        product: Product(
          prodId: id,
          vendorId: vendorId,
          productName: productProvider.productData['productName'],
          price: productProvider.productData['price'],
          quantity: productProvider.productData['quantity'],
          category: productProvider.productData['category'],
          description: productProvider.productData['description'],
          scheduleDate: productProvider.productData['scheduleDate'],
          isCharging: productProvider.productData['isCharging'],
          billingAmount: productProvider.productData['billingAmount'],
          brandName: productProvider.productData['brandName'],
          sizesAvailable: productProvider.productData['sizesAvailable'],
          downLoadImgUrls: productProvider.productData['downLoadImgUrls'],
          uploadDate: DateTime.now(),
        ),
      );

      if (result.success == null) {
        kCoolAlert(
          message: result.errorMessage!,
          context: cxt,
          alert: CoolAlertType.error,
          action: completeAction,
        );
      } else {
        productProvider.updateProductGeneralInfoState();
        productProvider.updateProductAttributeState();
        productProvider.updateProductShippingInfoState();
        productProvider.resetProductData();
        isLoadingFnc();
      }
    }

    return Scaffold(
      floatingActionButton: productProvider.isDoneSubmittingDetails() &&
              !productProvider.isProductImagesNull()
          ? Directionality(
              textDirection: TextDirection.rtl,
              child: FloatingActionButton.extended(
                backgroundColor: accentColor,
                onPressed: () => submitProduct(),
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  'Upload Product',
                ),
              ),
            )
          : const SizedBox.shrink(),
      body: !isLoading || !uploadingImageStatus
          ? Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 18,
              ),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          child: Center(
                            child: productImages == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      AssetManager.placeholderImg,
                                    ),
                                  )
                                // this will load imgUrl from firebase
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.file(
                                      File(productImages![currentImage].path),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => selectPhoto(),
                            child: const CircleAvatar(
                              backgroundColor: accentColor,
                              child: Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        productImages == null
                            ? const SizedBox.shrink()
                            : Positioned(
                                bottom: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    productProvider.clearProductImg();
                                  }),
                                  child: const CircleAvatar(
                                    backgroundColor: accentColor,
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  productImages == null
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productImages!.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  currentImage = index;
                                }),
                                child: Container(
                                  height: 60,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(productImages![index].path),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  productImages != null || doneUploadingImage
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor),
                          onPressed: () =>
                              uploadingImageStatus || doneUploadingImage
                                  ? showMsg()
                                  : uploadImages(),
                          child: uploadingImageStatus
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  doneUploadingImage
                                      ? 'Done uploading images'
                                      : 'Upload Images',
                                ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )
          : const Center(
              child: LoadingWidget(size: 50),
            ),
      bottomSheet: doneUploadingImage
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Upload images successfully',
                    style: getRegularStyle(color: accentColor),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.check_circle_outline,
                    color: accentColor,
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
