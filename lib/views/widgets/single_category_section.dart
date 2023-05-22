import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../models/category.dart';
import '../../resources/values_manager.dart';

class SingleCategorySection extends StatelessWidget {
  const SingleCategorySection({
    Key? key,
    required this.item,
    required this.index,
    required this.setCurrentIconSection,
    required this.currentIconSectionIndex,
  }) : super(key: key);
  final Category item;
  final int index;
  final Function setCurrentIconSection;
  final int currentIconSectionIndex;

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
            onTap: () => setCurrentIconSection(index),
            child: Container(
              height: 40,
              width: 50,
              decoration: BoxDecoration(
                color: currentIconSectionIndex == index ? accentColor : boxBg,
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
              child: Center(
                child: Image.asset(
                  item.imgUrl,
                  width: 50,
                  color: currentIconSectionIndex == index
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
