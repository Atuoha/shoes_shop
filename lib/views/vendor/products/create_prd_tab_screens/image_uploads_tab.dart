import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/constants/color.dart';
import 'package:shoes_shop/resources/assets_manager.dart';

import '../../../../constants/enums/status.dart';
import '../../../../providers/product.dart';
import '../../../widgets/msg_snackbar.dart';

import 'package:path/path.dart' as path;

class ImageUploadTab extends StatefulWidget {
  const ImageUploadTab({Key? key}) : super(key: key);

  @override
  State<ImageUploadTab> createState() => _ImageUploadTabState();
}

class _ImageUploadTabState extends State<ImageUploadTab> {
  List<XFile>? productImages;
  final ImagePicker _picker = ImagePicker();
  final firebaseStorage = FirebaseStorage.instance;
  var currentImage = 0;

  // get context
  get cxt => context;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductData>(context);
    List<XFile>? productImages = productProvider.productData['productImages'];

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
      productProvider.updateProductImg(productImages: pickedImages);
    }

    // submit product
    Future<void> submitProduct() async {
      List<String> downImgUrls = [];
      for (var img in productImages!) {
        var storageRef =
            firebaseStorage.ref('product-images/${path.basename(img.path)}');
        await storageRef.putFile(File(img.path)).whenComplete(() async {
          await storageRef.getDownloadURL().then(
                (value) => downImgUrls.add(value),
              );
        });
      }
    }

    return Scaffold(
      floatingActionButton: productProvider.isDoneSubmittingDetails() &&
              !productProvider.isProductImagesNull()
          ? Directionality(
              textDirection: TextDirection.rtl,
              child: FloatingActionButton.extended(
                backgroundColor: accentColor,
                onPressed: () => null,
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  'Upload Product',
                ),
              ),
            )
          : const SizedBox.shrink(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 20,
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
          ],
        ),
      ),
    );
  }
}
