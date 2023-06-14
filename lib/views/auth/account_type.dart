import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/color.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shoes_shop/views/widgets/kcool_alert.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../controllers/route_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({Key? key}) : super(key: key);

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  Stream<PermissionStatus>? _statusStream;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  // get context
  get cxt => context;

  // open app for storage
  Future<void> openSettingForStoragePermission() async {
    await openAppSettings(); // opens phone setting
    await Future.delayed(const Duration(seconds: 1));
    _statusStream = Permission.storage.status.asStream();
    _statusStream!.listen((status) {
      popOut(); // pop out dialog

      if (status.isDenied || status.isPermanentlyDenied) {
        Timer(const Duration(seconds: 1), () {
          requestPermission();
        });
      }
    });
  }

  // popOut
  popOut() {
    Navigator.of(context).pop();
  }

  requestPermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      kCoolAlert(
        message:
            'Opps! You denied us access to read from phone storage. This app requires permission in order to read files',
        context: cxt,
        alert: CoolAlertType.error,
        action: openSettingForStoragePermission,
        confirmBtnText: 'Allow',
        barrierDismissible: false,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    Widget authWidget({required String title, required String routeName}) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(routeName),
        child: Column(
          children: [
            Image.asset(
              AssetManager.avatar,
              width: 100,
              color: accentColor,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: getRegularStyle(color: accentColor),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.person_outline, color: accentColor),
                  Text(
                    'Select account type',
                    style: getMediumStyle(
                      color: accentColor,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.s30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  authWidget(
                    title: 'Customer',
                    routeName: RouteManager.customerAuthScreen,
                  ),
                  authWidget(
                    title: 'Vendor',
                    routeName: RouteManager.vendorAuthScreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
