import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../resources/assets_manager.dart';

class KCachedImage extends StatelessWidget {
  KCachedImage({
    super.key,
    required this.image,
    this.height = 70,
    this.width = 60,
    this.radius = 60,
    this.isCircleAvatar = false,
    this.isFit = true,
  });

  final String image;
  double height;
  double width;
  double radius;
  bool isCircleAvatar;
  bool isFit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => isCircleAvatar
          ? CircleAvatar(
              radius: radius,
              backgroundImage: imageProvider,
            )
          : Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: isFit ? BoxFit.cover : BoxFit.contain,
                ),
              ),
            ),
      placeholder: (context, url) => isCircleAvatar
          ? CircleAvatar(
              radius: radius,
              backgroundImage: const AssetImage(
                AssetManager.placeholderImg,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                AssetManager.placeholderImg,
              ),
            ),
      errorWidget: (context, url, error) => isCircleAvatar
          ? CircleAvatar(
              radius: radius,
              backgroundImage: const AssetImage(
                AssetManager.placeholderImg,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                AssetManager.placeholderImg,
              ),
            ),
    );
  }
}
