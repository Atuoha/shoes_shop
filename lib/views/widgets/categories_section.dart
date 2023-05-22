import 'package:flutter/material.dart';
import 'package:shoes_shop/views/widgets/single_category_section.dart';

import '../../models/category.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  var currentCarouselIndex = 0;
  var currentIconSectionIndex = 0;

  final List<Category> iconSections = [
    Category(
        id: '1', imgUrl: 'assets/images/categories/fila.png', title: 'Fila'),
    Category(
        id: '2',
        imgUrl: 'assets/images/categories/adidas.png',
        title: 'Adidas'),
    Category(
        id: '3', imgUrl: 'assets/images/categories/nike.png', title: 'Nike'),
    Category(
        id: '4',
        imgUrl: 'assets/images/categories/reebok.png',
        title: 'Reebok'),
    Category(
        id: '5', imgUrl: 'assets/images/categories/puma.png', title: 'Puma'),
  ];

  void setCurrentIconSection(int index) {
    setState(() {
      currentIconSectionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 8,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: iconSections.length,
        itemBuilder: (context, index) {
          var item = iconSections[index];
          return SingleCategorySection(
            item: item,
            index: index,
            setCurrentIconSection: setCurrentIconSection,
            currentIconSectionIndex: currentIconSectionIndex,
          );
        },
      ),
    );
  }
}
