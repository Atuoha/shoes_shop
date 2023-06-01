import 'package:flutter/material.dart';
import 'package:shoes_shop/resources/assets_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/color.dart';
import '../../controllers/route_manager.dart';
import '../../helpers/shared_prefs.dart';
import '../../models/splash_item.dart';
import '../../resources/font_manager.dart';
import '../../resources/string_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

import '../auth/account_type.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  var currentPageIndex = 0;

  // Future<int> getCurrentPageIndex() async{
  //   await Future.delayed(const Duration(seconds:0));
  //   return  _pageController.page?.round() ?? 0;
  // }

  void skipSlides() {
    _pageController.animateToPage(
      2,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  // n
  void nextSlide() {
    currentPageIndex != 2
        ? _pageController.nextPage(
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
          )
        : finishSplash();
  }

  // get context
  get ctxt {
    return context;
  }

  // finish splash
  void finishSplash() async {
    await setAppPreviouslyRun();
    Navigator.of(ctxt).pushNamed(RouteManager.accountType);
  }

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          currentPageIndex != splashItems.length - 1
              ? TextButton(
                  onPressed: () => skipSlides(),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: accentColor,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SmoothPageIndicator(
              controller: _pageController,
              count: splashItems.length,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 25,
                  height: 3,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                dotDecoration: DotDecoration(
                  width: 25,
                  height: 3,
                  color: greyShade,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => nextSlide(),
              child: Text(
                currentPageIndex != splashItems.length - 1
                    ? 'Next'
                    : 'Start Exploring',
              ),
            )
          ],
        ),
      ),
    );
  }
}
