import 'package:flutter/material.dart';
import '../../helpers/word_reverse.dart';
import '../../models/vendor.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../widgets/k_cached_image.dart';

class SingleStoreGridItem extends StatelessWidget {
  const SingleStoreGridItem({
    super.key,
    required this.vendor,
    required this.size,
  });

  final Vendor vendor;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        KCachedImage(
          image:  vendor.storeImgUrl,
          height:205,
          width:double.infinity,
        ),

        Positioned(
          bottom: 3,
          left: 3,
          right: 3,
          child: Container(
            height: size.height / 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.topCenter,
                stops: const [0, 1],
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(.03),
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        vendor.storeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          color: Colors.black,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vendor.city,
                          style: getRegularStyle(
                            color: Colors.black,
                            fontSize: FontSize.s14,
                          ),
                        ),
                        Text(
                          reversedWord(vendor.country),
                          style: getRegularStyle(
                            color: Colors.black,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
