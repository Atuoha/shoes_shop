import 'package:shoes_shop/views/auth/seller/forgot_password.dart';
import 'package:shoes_shop/views/auth/seller/seller_auth.dart';

import '../views/auth/account_type.dart';
import '../views/auth/customer/customer_auth.dart';
import '../views/auth/customer/forgot_password.dart';
import '../views/customer/main_screen.dart';
import '../views/splash/entry.dart';
import '../views/splash/splash.dart';

class RouteManager {
  static const String splashScreen = "/splash";
  static const String accountType = "/accountType";

  static const String customerAuthScreen = "/customerAuthScreen";
  static const String customerForgotPass = "/customerForgotPass";
  static const String signupAcknowledgeScreen = "/signupAcknowledge";
  static const String customerMainScreen = '/customerHomeScreen';

  static const String sellerAuthScreen = "/sellerAuthScreen";
  static const String sellerForgotPass = "/sellerForgotPass";
  static const String sellerMainScreen = '/sellerMainScreen';
  static const String sellerEntryScreen = '/sellerEntryScreen';

}

final routes = {
  RouteManager.splashScreen: (context) => const SplashScreen(),
  RouteManager.accountType: (context) => const AccountTypeScreen(),
  RouteManager.customerAuthScreen: (context) => const CustomerAuthScreen(),
  RouteManager.sellerAuthScreen: (context) => const SellerAuthScreen(),
  RouteManager.customerMainScreen: (context) => const CustomerMainScreen(),
  RouteManager.customerForgotPass: (context) => const CustomerForgotPassword(),
  RouteManager.sellerForgotPass: (context) => const SellerForgotPassword(),
};
