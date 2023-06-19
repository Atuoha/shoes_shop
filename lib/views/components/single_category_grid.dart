import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';

class SingleCategoryGridItem extends StatelessWidget {
  const SingleCategoryGridItem({
    super.key,
    required this.category,
    required this.size,
  });

  final Category category;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: category.imgUrl,
          imageBuilder: (context, imageProvider) => Hero(
            tag: category.id,
            child: Container(
              height: 205,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                ),
              ),
            ),
          ),
          placeholder: (context, url) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(AssetManager.placeholderImg),
          ),
          errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(AssetManager.placeholderImg),
          ),
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
                        category.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          color: Colors.black,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
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
