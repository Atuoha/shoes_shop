import 'package:flutter/material.dart';
import 'package:shoes_shop/resources/assets_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/color.dart';
import '../../models/splash_item.dart';
import '../../resources/font_manager.dart';
import '../../resources/string_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  List<SplashItem> splashItems = [
    SplashItem(
      title: StringManager.splashTitle1,
      subTitle: StringManager.splashSubtitle1,
      imgUrl: AssetManager.splashImage1,
    ),
    SplashItem(
      title: StringManager.splashTitle2,
      subTitle: StringManager.splashSubtitle2,
      imgUrl: AssetManager.splashImage2,
    ),
    SplashItem(
      title: StringManager.splashTitle3,
      subTitle: StringManager.splashSubtitle3,
      imgUrl: AssetManager.splashImage3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: splashItems.length,
        itemBuilder: (context, index) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(splashItems[index].imgUrl),
            const SizedBox(height: AppSize.s10),
            Text(
              splashItems[index].title,
              style: getBoldStyle(
                color: accentColor,
                fontSize: FontSize.s30,
              ),
            ),
            Text(
              splashItems[index].subTitle,
              style: getLightStyle(
                color: accentColor,
                fontSize: FontSize.s20,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SmoothPageIndicator(
          controller: _pageController,
          count: splashItems.length,
          effect: CustomizableEffect(
            activeDotDecoration: DotDecoration(
              width: 25,
              height: 3,
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            dotDecoration:  DotDecoration(
                width: 25,
                height: 3,
                color: greyShade,
                borderRadius: BorderRadius.circular(20)
            ),
          ),
        ),
      ),
    );
  }
}
