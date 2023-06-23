import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../constants/firebase_refs/collections.dart';
import '../../resources/assets_manager.dart';
import 'loading_widget.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({Key? key}) : super(key: key);

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final List<String> _banners = [];

  Future<void> _fetchBanners() async {
    await FirebaseCollections.bannersCollection
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var data in querySnapshot.docs) {
        setState(() {
          _banners.add(data['img_url']);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBanners();

  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: _banners.length,
      itemBuilder: (context, i, index) => _banners.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: _banners[i],
                placeholder: (context, url) =>
                    Image.asset(AssetManager.emptyImg),
                errorWidget: (context, url, error) =>
                    Image.asset(AssetManager.emptyImg),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(AssetManager.emptyImg),
            ),
      options: CarouselOptions(
        height: 150,
        viewportFraction: 0.5,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
    );
  }
}
