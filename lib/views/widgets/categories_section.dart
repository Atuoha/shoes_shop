import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/views/widgets/single_category_section.dart';

import '../../models/category.dart';
import 'loading_widget.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  var currentCarouselIndex = 0;
  var currentIconSectionIndex = 0;
  bool isLoading = true;

  final List<Category> categories = [
    // Category(
    //     id: '1', imgUrl: 'assets/images/categories/fila.png', title: 'Fila'),
    // Category(
    //   id: '2',
    //   imgUrl: 'assets/images/categories/adidas.png',
    //   title: 'Adidas',
    // ),
    // Category(
    //   id: '3',
    //   imgUrl: 'assets/images/categories/nike.png',
    //   title: 'Nike',
    // ),
    // Category(
    //     id: '4',
    //     imgUrl: 'assets/images/categories/reebok.png',
    //     title: 'Reebok'),
    // Category(
    //   id: '5',
    //   imgUrl: 'assets/images/categories/puma.png',
    //   title: 'Puma',
    // ),
  ];

  Future<void> _fetchCategories() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        categories.add(
          Category(
            id: doc.id,
            title: doc['category'],
            imgUrl: doc['img_url'],
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void setCurrentIconSection(int index) {
    setState(() {
      currentIconSectionIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    _fetchCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 8,
      child: !isLoading
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var item = categories[index];
                return SingleCategorySection(
                  item: item,
                  index: index,
                  setCurrentIconSection: setCurrentIconSection,
                  currentIconSectionIndex: currentIconSectionIndex,
                );
              },
            )
          : const Center(child: LoadingWidget(size: 20)),
    );
  }
}
