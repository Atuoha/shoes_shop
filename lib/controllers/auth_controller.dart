import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/enums/account_type.dart';
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

      if (e.message != null) {
        if (e.code == 'user-not-found') {
          response = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          response = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          response = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          response = 'Network error! Try connecting your internet';
        } else {
          response = e.code;
        }
      }
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
        });
      } else {
        firebase.collection('customers').doc(credential.user!.uid).set({
          'fullname': fullname,
          'email': email,
          'image': downloadUrl,
          'auth-type': 'email',
          'phone': phone,
          'address': '',
        });
      }
      return AuthResult.success(credential.user);
    } on FirebaseAuthException catch (e) {
      var response = 'error';
      if (e.message != null) {
        if (e.code == 'user-not-found') {
          response = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          response = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          response = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          response = 'Network error!';
        } else {
          response = e.code;
        }
      }
      return AuthResult.error(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AuthResult?> googleAuth(AccountType accountType) async {
    var response = 'success';

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
          },
        );
      }
      // sign in with credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        if (e.code == 'user-not-found') {
          response = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          response = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          response = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          response = 'Network error!';
        } else {
          response = e.code;
        }
      }
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
