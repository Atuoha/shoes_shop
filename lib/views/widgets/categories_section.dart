import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/views/widgets/single_category_section.dart';

import '../../models/category.dart';
import '../../providers/category.dart';
import 'loading_widget.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({
    Key? key,
    required this.categoryProvider,
  }) : super(key: key);
  final CategoryData categoryProvider;

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  var currentCategoryIndex = 0;
  String? currentCategoryTitle;
  bool isLoading = true;

  void setCurrentIconSection(int index, String title) {
    setState(() {
      currentCategoryIndex = index;
      currentCategoryTitle = title;
    });
    widget.categoryProvider.updateCategory(title);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Stream<QuerySnapshot> streamCategory =
        FirebaseFirestore.instance.collection('categories').snapshots();

    return SizedBox(
      height: size.height / 8,
      child: StreamBuilder<QuerySnapshot>(
        stream: streamCategory,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'An error has occurred!',
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingWidget(size: 50),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var item = snapshot.data!.docs[index];
              Category category = Category(
                id: index.toString(),
                title: item['category'],
                imgUrl: item['img_url'],
              );

              setState(() {
                setCurrentIconSection(index, category.title);
              });

              return snapshot.data!.docs.isNotEmpty
                  ? SingleCategorySection(
                      item: Category(
                        id: category.id,
                        title: category.title,
                        imgUrl: category.imgUrl,
                      ),
                      index: index,
                      setCurrentCategory: setCurrentIconSection,
                      currentCategoryIndex: currentCategoryIndex,
                    )
                  : const Center(
                      child: Text('Categories is empty'),
                    );
            },
          );
        },
      ),
    );
  }
}
