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

String extractErrorMessage(String exceptionMessage) {
  // Extract the first value before the comma inside the brackets
  RegExp regex = RegExp(r'\((.*?)\)');
  RegExpMatch? match = regex.firstMatch(exceptionMessage);
  String errorMessage = 'Unknown error';

  if (match != null) {
    String? bracketContent = match.group(1);
    List<String> parts = bracketContent!.split(',');
    if (parts.isNotEmpty) {
      errorMessage = parts.first.trim();
    }
  }

  return errorMessage;
}
