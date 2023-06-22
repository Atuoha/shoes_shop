import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/views/components/single_category_section.dart';
import '../../constants/firebase_refs/collections.dart';
import '../../models/category.dart';
import '../../providers/category.dart';
import '../../resources/assets_manager.dart';
import '../widgets/loading_widget.dart';

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
  int currentCategoryIndex = 0;
  String? currentCategoryTitle;
  bool isLoading = true;

  void setCurrentIconSection(int index, String title) {
    currentCategoryIndex = index;
    currentCategoryTitle = title;
    widget.categoryProvider.updateCategory(title);
  }

  // implemented this using streamBuilder. A previous commit has a another suitable version

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    Stream<QuerySnapshot> streamCategory =
        FirebaseCollections.categoriesCollection.snapshots();

    return SizedBox(
      height: size.height / 8,
      child: StreamBuilder<QuerySnapshot>(
        stream: streamCategory,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      AssetManager.warningImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('An error occurred!'),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingWidget(size: 30),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      AssetManager.addImage,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('Category list is empty'),
                ],
              ),
            );
          }

          // hard coding an "All Category" and adding it to the list
          List<Category> combinedList = [
            Category(
              id: 'title',
              title: '',
              imgUrl: AssetManager.allNetworkImage,
            ),
            ...snapshot.data!.docs.map((item) => Category.fromJson(item))
          ];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: combinedList.length,
            itemBuilder: (context, index) {
              var item = combinedList[index];

              return SingleCategorySection(
                item: Category(
                  id: item.id,
                  title: item.title,
                  imgUrl: item.imgUrl,
                ),
                index: index,
                setCurrentCategory: setCurrentIconSection,
                currentCategoryIndex: currentCategoryIndex,
              );
            },
          );
        },
      ),
    );
  }
}
