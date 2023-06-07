import 'package:shared_preferences/shared_preferences.dart';

import '../constants/enums/account_type.dart';

// check if app has ran before
Future<bool> checkIfAppPreviouslyRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isAppPreviouslyRun') ?? false;
}

// set appIsPreviouslyRun
Future<void> setAppPreviouslyRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isAppPreviouslyRun', true);
}



// set account type
Future<void> setAccountType({required AccountType accountType}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(
    'isCustomer',
    accountType == AccountType.customer ? true : false,
  );
}



// check account type
Future<bool> checkAccountType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isCustomer') ?? true;
}
