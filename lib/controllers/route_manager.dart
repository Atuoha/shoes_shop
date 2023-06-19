import 'package:shoes_shop/views/auth/vendor/forgot_password.dart';
import 'package:shoes_shop/views/auth/vendor/vendor_auth.dart';
import 'package:shoes_shop/views/customer/relational_screens/product_details.dart';
import 'package:shoes_shop/views/vendor/orders/orders.dart';

import '../views/auth/account_type.dart';
import '../views/auth/customer/customer_auth.dart';
import '../views/auth/customer/forgot_password.dart';
import '../views/customer/main_screen.dart';
import '../views/vendor/entry_screen.dart';
import '../views/splash/splash.dart';
import '../views/vendor/main_screen.dart';
import '../views/vendor/products/create.dart';

class RouteManager {
  static const String splashScreen = "/splash";
  static const String accountType = "/accountType";

  static const String customerAuthScreen = "/customerAuthScreen";
  static const String customerForgotPass = "/customerForgotPass";
  static const String signupAcknowledgeScreen = "/signupAcknowledge";
  static const String customerMainScreen = '/customerHomeScreen';
  static const String ordersScreen = 'ordersScreen';

  static const String vendorAuthScreen = "/vendorAuthScreen";
  static const String vendorForgotPass = "/vendorForgotPass";
  static const String vendorMainScreen = '/vendorMainScreen';
  static const String vendorEntryScreen = '/vendorEntryScreen';
  static const String vendorCreatePost = '/vendorCreatePost';
}

final routes = {
  RouteManager.splashScreen: (context) => const SplashScreen(),
  RouteManager.accountType: (context) => const AccountTypeScreen(),
  RouteManager.customerAuthScreen: (context) => const CustomerAuthScreen(),
  RouteManager.customerMainScreen: (context) => const CustomerMainScreen(),
  RouteManager.customerForgotPass: (context) => const CustomerForgotPassword(),
  RouteManager.ordersScreen: (context) => const OrdersScreen(),
  RouteManager.vendorAuthScreen: (context) => const VendorAuthScreen(),
  RouteManager.vendorMainScreen: (context) => const VendorMainScreen(index: 0),
  RouteManager.vendorEntryScreen: (context) => const VendorEntryScreen(),
  RouteManager.vendorForgotPass: (context) => const VendorForgotPassword(),
  RouteManager.vendorCreatePost: (context) => const VendorCreatePost(),
};
