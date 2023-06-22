import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final String imgUrl;

  Category({
    required this.id,
    required this.title,
    required this.imgUrl,
  });

  Category.fromJson(QueryDocumentSnapshot item)
      : this(
          id: item['category'],
          title: item['category'],
          imgUrl: item['img_url'],
        );
}
