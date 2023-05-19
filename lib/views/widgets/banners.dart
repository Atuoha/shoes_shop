import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({Key? key}) : super(key: key);

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final List<String> _banners = [
    'assets/images/banners/ba1.jpg',
    'assets/images/banners/ba2.jpg',
    'assets/images/banners/ba3.png',
    'assets/images/banners/ba4.png',
    'assets/images/banners/ba5.png',
    'assets/images/banners/ba6.png',
  ];
  final firebaseFirestore = FirebaseFirestore.instance;

  void _fetchBanners() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: _banners.length,
      itemBuilder: (context, i, index) => Image.asset(_banners[i]),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
    );
  }
}
