import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/views/widgets/kcool_alert.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/account_type.dart';
import '../../../constants/enums/fields.dart';
import '../../../constants/enums/status.dart';
import '../../../constants/firebase_refs/collections.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/route_manager.dart';
import '../../../helpers/auth_error_formatter.dart';
import '../../../helpers/shared_prefs.dart';
import '../../../models/auth_result.dart';
import '../../../resources/assets_manager.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/msg_snackbar.dart';
import '../../../helpers/image_picker.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

class VendorAuthScreen extends StatefulWidget {
  const VendorAuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VendorAuthScreen> createState() => _VendorAuthScreenState();
}

class _VendorAuthScreenState extends State<VendorAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  final _taxNumberController = TextEditingController();
  final _storeNumberController = TextEditingController();

  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  var obscure = true; // password obscure value
  var isLogin = true;
  File? profileImage;
  var isLoading = false;
  final firebase = FirebaseFirestore.instance;
  final AuthController _authController = AuthController();

  bool isStoreRegistered = false;

  // toggle password obscure
  _togglePasswordObscure() {
    setState(() {
      obscure = !obscure;
    });
  }

  // get context
  get ctxt {
    return context;
  }

  // custom textfield for all form fields
  Widget kTextField(
    TextEditingController controller,
    String hint,
    String label,
    Field field,
    bool obscureText,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: field == Field.email
          ? TextInputType.emailAddress
          : field == Field.phone
              ? TextInputType.phone
              : field == Field.storeRegNo || field == Field.taxNumber
                  ? TextInputType.number
                  : TextInputType.text,
      textInputAction:
          field == Field.password ? TextInputAction.done : TextInputAction.next,
      autofocus: field == Field.email ? true : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: accentColor),
        suffixIcon: field == Field.password
            ? _passwordController.text.isNotEmpty
                ? IconButton(
                    onPressed: () => _togglePasswordObscure(),
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: accentColor,
                    ),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
        hintText: hint,
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
        switch (field) {
          case Field.email:
            if (!value!.contains('@')) {
              return 'Email is not valid!';
            }
            if (value.isEmpty) {
              return 'Email can not be empty';
            }
            break;

          case Field.fullname:
            if (value!.isEmpty || value.length < 3) {
              return 'Fullname is not valid';
            }
            break;

          case Field.phone:
            if (value!.isEmpty || value.length < 10) {
              return 'Phone number is not valid';
            }
            break;

          case Field.taxNumber:
            if (value!.isEmpty || value.length < 8) {
              return 'Tax number needs to be valid';
            }
            break;

          case Field.storeRegNo:
            if (value!.isEmpty || value.length < 8) {
              return 'Store registration number needs to be valid';
            }
            break;

          case Field.password:
            if (value!.isEmpty || value.length < 8) {
              return 'Password needs to be valid';
            }
            break;
        }
        return null;
      },
    );
  }

  // for selecting photo
  _selectPhoto(File image) {
    setState(() {
      profileImage = image;
    });
  }

  // context
  get cxt => context;

  // routing to the main screen or the entry screen based on whether approved or not
  routingVendor() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var data = await FirebaseCollections.vendorsCollection
        .doc(userId)
        .get();

    if (data['isApproved']) {
      // account approved
      Timer(
        const Duration(seconds: 2),
        () => Navigator.of(cxt).pushNamedAndRemoveUntil(
            RouteManager.vendorMainScreen, (route) => false),
      );
    } else {
      // account not approved
      Timer(
        const Duration(seconds: 2),
        () => Navigator.of(cxt).pushNamedAndRemoveUntil(
          RouteManager.vendorEntryScreen,
          (route) => false,
        ),
      );
    }
  }

  // loading fnc
  isLoadingFnc() async {
    setState(() {
      isLoading = true;
    });
    // routing vendor
    routingVendor();

    // set account type to vendor
    await setAccountType(accountType: AccountType.vendor);
  }

  // called after an action is completed
  void completeAction() {
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  // handle sign in and  sign up
  _handleAuth() async {
    var valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    if (!valid) {
      displaySnackBar(
        message: 'Form needs to be accurately filled',
        status: Status.error,
        context: context,
      );
      return null;
    }

    if (isLogin) {
      // TODO: implement sign in
      setState(() {
        isLoading = true;
      });

      AuthResult? result = await _authController.signInUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (result!.user == null) {
        kCoolAlert(
          message: result.errorMessage!,
          context: ctxt,
          alert: CoolAlertType.error,
          action: completeAction,
        );
      } else {
        isLoadingFnc();
      }
    } else {
      // TODO: implement sign up
      if (profileImage == null) {
        // store image is empty
        displaySnackBar(
          message: 'Store image can not be empty!',
          status: Status.error,
          context: context,
        );
        return null;
      }

      if (_cityController.text.isEmpty) {
        // city is empty
        displaySnackBar(
          message: 'You need to select your complete location!',
          status: Status.error,
          context: context,
        );
        return null;
      }

      setState(() {
        isLoading = true;
      });

      AuthResult? result = await _authController.signUpUser(
        email: _emailController.text.trim(),
        fullname: _storeNameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        accountType: AccountType.vendor,
        profileImage: profileImage,
        country: _countryController.text,
        state: _stateController.text,
        city: _cityController.text,
        taxNumber: _taxNumberController.text.trim(),
        storeRegNo: _storeNumberController.text.trim(),
        isStoreRegistered: isStoreRegistered,
      );

      if (result!.user == null) {
        kCoolAlert(
          message: result.errorMessage!,
          context: ctxt,
          alert: CoolAlertType.error,
          action: completeAction,
        );
      } else {
        isLoadingFnc();
      }
    }
  }

// authenticate using Google
  _googleAuth() async {
    setState(() {
      isLoading = true;
    });

    try {
      AuthResult? result = await _authController.googleAuth(
        AccountType.vendor,
      );

      if (result!.user != null) {
        isLoadingFnc();
      } else {
        kCoolAlert(
          message: result.errorMessage!,
          context: ctxt,
          alert: CoolAlertType.error,
          action: completeAction,
        );
      }
    } catch (e) {
      kCoolAlert(
        message: extractErrorMessage(e.toString()),
        context: ctxt,
        alert: CoolAlertType.error,
        action: completeAction,
      );
    }
  }

  // navigate to forgot password screen
  _forgotPassword() {
    Navigator.of(context).pushNamed(RouteManager.vendorForgotPass);
  }

  // switch authentication mode
  _switchLog() {
    setState(() {
      isLogin = !isLogin;
      _passwordController.text = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  !isLogin
                      ? ProfileImagePicker(selectImage: _selectPhoto)
                      : Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            child: Image.asset(AssetManager.loginImage),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      isLogin ? 'Vendor Signin ' : 'Vendor Signup',
                      style: const TextStyle(
                        color: accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const Center(
                          child: LoadingWidget(
                            size: 70,
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              kTextField(
                                _emailController,
                                'doe_store@gmail.com',
                                'Email Address',
                                Field.email,
                                false,
                              ),
                              const SizedBox(height: 10),
                              !isLogin
                                  ? kTextField(
                                      _storeNameController,
                                      'Doe Store',
                                      'Store name',
                                      Field.fullname,
                                      false,
                                    )
                                  : const SizedBox.shrink(),
                              SizedBox(height: isLogin ? 0 : 10),
                              !isLogin
                                  ? kTextField(
                                      _phoneController,
                                      '+234-000-000-000',
                                      'Phone Number',
                                      Field.phone,
                                      false,
                                    )
                                  : const SizedBox.shrink(),
                              SizedBox(height: isLogin ? 0 : 10),
                              kTextField(
                                _passwordController,
                                '********',
                                'Password',
                                Field.password,
                                obscure,
                              ),

                              if (!isLogin) ...[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SelectState(
                                    onCountryChanged: (value) {
                                      setState(() {
                                        _countryController.text = value;
                                      });
                                    },
                                    onStateChanged: (value) {
                                      setState(() {
                                        _stateController.text = value;
                                      });
                                    },
                                    onCityChanged: (value) {
                                      setState(() {
                                        _cityController.text = value;
                                      });
                                    },
                                  ),
                                ),
                                CheckboxListTile(
                                  value: isStoreRegistered,
                                  onChanged: (value) {
                                    setState(() {
                                      isStoreRegistered = value!;
                                    });
                                  },
                                  title: const Text(
                                      'Have you registered your store?'),
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              ],

                              // tax details
                              if (!isLogin && isStoreRegistered) ...[
                                kTextField(
                                  _storeNumberController,
                                  '90988777880',
                                  'Store Reg Number',
                                  Field.storeRegNo,
                                  false,
                                ),
                                const SizedBox(height: 10),
                                kTextField(
                                  _taxNumberController,
                                  '90988777880',
                                  'TIN Number',
                                  Field.taxNumber,
                                  false,
                                ),
                              ],

                              SizedBox(height: isLogin ? 30 : 10),
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
                                  icon: Icon(
                                    isLogin
                                        ? Icons.person
                                        : Icons.person_add_alt_1,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _handleAuth(),
                                  label: Text(
                                    isLogin
                                        ? 'Signin Account'
                                        : 'Signup Account',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                ),
                                onPressed: () => _googleAuth(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google.png',
                                      width: 20,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      isLogin
                                          ? 'Signin with google'
                                          : 'Signup with google',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => _forgotPassword(),
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => _switchLog(),
                                    child: Text(
                                      isLogin
                                          ? 'New here? Create Account'
                                          : 'Already a vendor? Sign in',
                                      style: const TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
