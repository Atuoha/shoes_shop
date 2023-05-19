import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../resources/assets_manager.dart';
import 'loading_widget.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({Key? key}) : super(key: key);

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  bool loading = true;
  final List<String> _banners = [];
  final firebaseFirestore = FirebaseFirestore.instance;

  Future<void> _fetchBanners() async {
    await firebaseFirestore
        .collection('banners')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var data in querySnapshot.docs) {
        setState(() {
          _banners.add(data['img_url']);
          loading = false;
        });
      }
    });
  }

  @override
  void initState() {
    _fetchBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: _banners.length,
      itemBuilder: (context, i, index) => loading
          ? const Center(child: LoadingWidget(size: 50))
          : _banners.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(_banners[i]),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(AssetManager.emptyImgCarousel),
                ),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
    );
  }
}
