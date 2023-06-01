import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkIfAppPreviouslyRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isAppPreviouslyRun') ?? false;
}


Future<void> setAppPreviouslyRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isAppPreviouslyRun', true);
}
