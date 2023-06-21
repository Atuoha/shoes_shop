import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static Future<void> fetchApiKeys() async {
    String flutterwavePublicKey = '';

    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 10),
        ),
      );
      await remoteConfig.fetchAndActivate();
      flutterwavePublicKey = remoteConfig.getString('flutterwave_public_key');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    const storage = FlutterSecureStorage();
    await storage.write(
        key: 'flutterwave_public_key', value: flutterwavePublicKey);
    String? apiPublicKey = await storage.read(key: 'flutterwave_public_key');
    if (kDebugMode) {
      print('PUBLIC KEY:$apiPublicKey');
    }
  }
}
