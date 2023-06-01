import 'package:firebase_auth/firebase_auth.dart';

String authErrorFormatter(FirebaseAuthException e) {
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

  return response;
}
