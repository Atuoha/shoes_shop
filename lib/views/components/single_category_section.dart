import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../models/category.dart';
import '../../resources/assets_manager.dart';
import '../../resources/values_manager.dart';

class SingleCategorySection extends StatelessWidget {
  const SingleCategorySection({
    Key? key,
    required this.item,
    required this.index,
    required this.setCurrentCategory,
    required this.currentCategoryIndex,
  }) : super(key: key);
  final Category item;
  final int index;
  final Function setCurrentCategory;
  final int currentCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 13,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setCurrentCategory(index,item.title),
            child: Container(
              height: 40,
              width: 50,
              decoration: BoxDecoration(
                color: currentCategoryIndex == index ? accentColor : boxBg,
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: item.imgUrl,
                  placeholder: (context, url) =>
                      Image.asset(AssetManager.addImage,fit:BoxFit.cover),
                  errorWidget: (context, url, error) =>
                      Image.asset(AssetManager.addImage,fit:BoxFit.cover),
                  width: 50,
                  color: currentCategoryIndex == index
                      ? Colors.white
                      : iconColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSize.s10),
          Text(
            item.title,
            style: const TextStyle(color: greyFontColor),
          ),
        ],
      ),
    );
  }
}
