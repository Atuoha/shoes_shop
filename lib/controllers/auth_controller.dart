import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/enums/account_type.dart';
import '../helpers/auth_error_formatter.dart';
import '../models/auth_result.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<AuthResult?> signInUser(String email, String password) async {
    try {
      var credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(credential.user);
    } on FirebaseAuthException catch (e) {
      var response = 'error occurred!';

      var error = authErrorFormatter(e);
      response = error;
      return AuthResult.error(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AuthResult?> signUpUser(
    String email,
    String fullname,
    String phone,
    String password,
    AccountType accountType,
    File? profileImage,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // upload img
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user-images')
          .child('${credential.user!.uid}.jpg');

      File? file;
      file = File(profileImage!.path);

      await storageRef.putFile(file);
      var downloadUrl = await storageRef.getDownloadURL();
      if (accountType == AccountType.seller) {
        firebase.collection('sellers').doc(credential.user!.uid).set({
          'fullname': fullname,
          'email': email,
          'image': downloadUrl,
          'auth-type': 'email',
          'phone': phone,
          'address': '',
          'sellerId': credential.user!.uid,
        });
      } else {
        firebase.collection('customers').doc(credential.user!.uid).set({
          'fullname': fullname,
          'email': email,
          'image': downloadUrl,
          'auth-type': 'email',
          'phone': phone,
          'address': '',
          'customerId': credential.user!.uid,
        });
      }
      return AuthResult.success(credential.user);
    } on FirebaseAuthException catch (e) {
      var response = 'error';
      var error = authErrorFormatter(e);
      response = error;
      return AuthResult.error(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AuthResult?> googleAuth(AccountType accountType) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      // send username, email, and phone number to firestore
      var logCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (accountType == AccountType.seller) {
        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(logCredential.user!.uid)
            .set(
          {
            'fullname': googleUser!.displayName,
            'email': googleUser.email,
            'image': googleUser.photoUrl,
            'auth-type': 'google',
            'phone': '',
            'address': '',
            'sellerId': logCredential.user!.uid,
          },
        );
      } else {
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(logCredential.user!.uid)
            .set(
          {
            'fullname': googleUser!.displayName,
            'email': googleUser.email,
            'image': googleUser.photoUrl,
            'auth-type': 'google',
            'phone': '',
            'address': '',
            'customerId': logCredential.user!.uid,
          },
        );
      }
      // sign in with credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      var response = 'error';

      var error = authErrorFormatter(e);
      response = error;
      return AuthResult.error(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    try {
      _auth.signOut();
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
