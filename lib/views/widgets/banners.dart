import 'package:flutter/material.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({Key? key}) : super(key: key);

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  PageController _pageController =  PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
      ),
      child: PageView(
        controller:_pageController,
        children:[
          Image.asset('assets/images/Sliders/1.jpg', fit: BoxFit.cover),
          Image.asset('assets/images/Sliders/2.jpg', fit: BoxFit.cover),
          Image.asset('assets/images/Sliders/3.jpg', fit: BoxFit.cover),
          Image.asset('assets/images/Sliders/6.jpg', fit: BoxFit.cover)

        ]
      ),
    );
  }
}
