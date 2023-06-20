import 'package:flutter/material.dart';
import 'package:shoes_shop/controllers/route_manager.dart';
import 'package:shoes_shop/resources/assets_manager.dart';
import '../../../constants/color.dart';

class VendorForgotPassword extends StatefulWidget {
  const VendorForgotPassword({Key? key}) : super(key: key);

  @override
  State<VendorForgotPassword> createState() => _VendorForgotPasswordState();
}

class _VendorForgotPasswordState extends State<VendorForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // handle forgot password
  _handleForgotPassword() {
    var valid = _formKey.currentState!.validate();
    if (!valid) {
      return null;
    }
    // TODO: Implement forgot password
  }

  // navigate to sign in screen
  _navigateToSignIn() {
    Navigator.of(context).pushNamed(RouteManager.vendorAuthScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                child: Image.asset(AssetManager.forgotImage),
              ),
            ),
            const Center(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'doe_store@gmail.com',
                      labelText: 'Email Address',
                      labelStyle: const TextStyle(color: accentColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 2,
                          color: accentColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (!value!.contains('@')) {
                        return 'Email is not valid!';
                      }
                      if (value.isEmpty) {
                        return 'Email can not be empty';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(15),
                      ),
                      icon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      onPressed: () => _handleForgotPassword(),
                      label: const Text(
                        'Submit Request',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _navigateToSignIn(),
                    child: const Text(
                      'Remembered password? Sign in',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
