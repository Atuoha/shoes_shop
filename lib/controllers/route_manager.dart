

import '../views/auth/account_type.dart';
import '../views/customers/main_screen.dart';
import '../views/splash/entry.dart';
import '../views/splash/splash.dart';

class RouteManager {
  static const String splashScreen = "/splash";
  static const String entryScreen = "/entry_screen";
  static const String accountType = "/accountType";

  static const String authScreen = "/auth";
  static const String forgotPasswordScreen = "/forgotPasswordScreen";
  static const String signupAcknowledgeScreen = "/signupAcknowledge";
  static const String customerMainScreen = '/customerHomeScreen';



  static const String sellerMainScreen = '/sellerMainScreen';

}

final routes = {
  RouteManager.splashScreen: (context) => const SplashScreen(),
  RouteManager.entryScreen: (context) => const EntryScreen(),
  RouteManager.accountType: (context) => const AccountTypeScreen(),
  RouteManager.customerMainScreen: (context)=> CustomerMainScreen(),

};
