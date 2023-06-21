import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static Future<void> fetchApiKeys() async {
    String flutterwavePublicKey = '';
    String flutterwaveEncryptKey = '';

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
      flutterwaveEncryptKey = remoteConfig.getString('flutterwave_encrypt_key');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    const storage = FlutterSecureStorage();
    await storage.write(
        key: 'flutterwave_public_key', value: flutterwavePublicKey);
    await storage.write(
        key: 'flutterwave_encrypt_key', value: flutterwaveEncryptKey);
  }
}
