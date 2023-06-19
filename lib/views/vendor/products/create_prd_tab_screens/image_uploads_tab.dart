import 'dart:async';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/constants/color.dart';
import 'package:shoes_shop/resources/assets_manager.dart';
import '../../../../constants/enums/status.dart';
import '../../../../controllers/product_controller.dart';
import '../../../../controllers/route_manager.dart';
import '../../../../models/product.dart';
import '../../../../models/request_result.dart';
import '../../../../providers/product.dart';
import '../../../../resources/styles_manager.dart';
import '../../../widgets/kcool_alert.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/msg_snackbar.dart';

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
  bool fetchingImages = false;
  var currentImage = 0;
  List<XFile>? productImages = [];
  bool stayOnPage = false;

  // get context
  get cxt => context;

  // loading fnc
  isLoadingFnc() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2));

    Timer(const Duration(seconds: 2), () {
      kCoolAlert(
        message: 'Product uploaded successfully',
        context: context,
        alert: CoolAlertType.success,
        action: completeSuccessAction,
      );
    });
  }

  // called after a failure upload action is completed
  void completeFailureAction() {
    setState(() {
      isLoading = false;
      doneUploadingImage = false;
    });
    Navigator.of(context).pop();
  }

  // called after a success upload action is completed
  void completeSuccessAction() {
    setState(() {
      isLoading = false;
      doneUploadingImage = false;
      productImages = [];
    });

    if (stayOnPage) {
      Navigator.of(context).pushReplacementNamed(RouteManager.vendorCreatePost);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const VendorMainScreen(index: 2),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final productProvider = Provider.of<ProductData>(context);

    // for selecting photo
    Future selectPhoto() async {
      setState(() {
        fetchingImages = true;
      });
      List<XFile>? pickedImages;

      pickedImages = await _picker.pickMultiImage(
        maxWidth: 600,
        maxHeight: 600,
      );

      // if (pickedImages ) {
      //   return null;
      // }

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
        fetchingImages = false;
      });
    }

    // show snackbar msg
    void showMsg() {
      displaySnackBar(
        status: Status.success,
        message: uploadingImageStatus
            ? 'Image is still trying to upload'
            : 'Image has fully uploaded. Upload Product Now!',
        context: context,
      );
    }

    // uploadImages to both firebase and persisting using provider
    void uploadImages() async {
      setState(() {
        uploadingImageStatus = true;
      });

      // upload images to firebase
      List<String> imgUrls = [];
      try {
        for (var img in productImages!) {
          var storageRef = firebaseStorage.ref('product-images/${uuid.v4()}');
          await storageRef.putFile(File(img.path)).whenComplete(() async {
            await storageRef.getDownloadURL().then((value) {
              imgUrls.add(value);
            });
          });
        }
      } catch (e) {
        setState(() {
          uploadingImageStatus = false;
        });
        displaySnackBar(
          status: Status.error,
          message: 'Error uploading product images',
          context: cxt,
        );
      }

      setState(() {
        uploadingImageStatus = false;
        doneUploadingImage = true;
      });

      // persist imgUrls using provider
      productProvider.updateProductImg(
        imgUrls: imgUrls,
      );
    }

    // submit product
    Future<void> submitProduct() async {
      if (kDebugMode) {
        print(productProvider.productData);
      }
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
          imgUrls: productProvider.productData['imgUrls'],
          uploadDate: DateTime.now(),
        ),
      );

      if (result.success == null) {
        kCoolAlert(
          message: result.errorMessage!,
          context: cxt,
          alert: CoolAlertType.error,
          action: completeFailureAction,
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
      floatingActionButton: productProvider.isDoneSubmittingDetails()
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
      body: !isLoading
          ? SingleChildScrollView(
            child: Padding(
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
                              child: productImages!.isEmpty
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

                          // image selection trigger
                          doneUploadingImage || uploadingImageStatus
                              ? const SizedBox.shrink()
                              : Positioned(
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

                          // deleting of images trigger
                          productImages!.isEmpty ||
                                  doneUploadingImage ||
                                  uploadingImageStatus
                              ? const SizedBox.shrink()
                              : Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      productProvider.clearProductImg();
                                      productImages = [];
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

                    // show a loading spinner while trying to fetch images from gallery
                    fetchingImages
                        ? const Column(
                            children: [
                              LoadingWidget(size: 30),
                              SizedBox(height: 10),
                              Text('Loading images'),
                            ],
                          )
                        : const SizedBox.shrink(),

                    const SizedBox(height: 10),

                    productImages!.isEmpty
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

                    productImages!.isNotEmpty
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
                                        ? 'Image uploaded and saved'
                                        : 'Upload Images',
                                  ),
                          )
                        : const SizedBox.shrink(),

                    const SizedBox(height: 10),

                    doneUploadingImage
                        ? CheckboxListTile(
                            checkColor: Colors.white,
                            activeColor: accentColor,
                            side: const BorderSide(
                              color: accentColor,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            title: const Text(
                              'Stay on this page after uploading product?',
                            ),
                            value: stayOnPage,
                            onChanged: (value) => setState(() {
                              stayOnPage = value!;
                            }),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
          )

          // loading is true
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingWidget(size: 50),
                  SizedBox(height: 10),
                  Text('Uploading...')
                ],
              ),
            ),
      bottomSheet: doneUploadingImage
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Uploaded images successfully',
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
