import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;
  final String? errorMessage;

  AuthResult({this.user, this.errorMessage});

  factory AuthResult.success(User? user) =>
      AuthResult(user: user, errorMessage: null);

  factory AuthResult.error(String errorMessage) =>
      AuthResult(user: null, errorMessage: errorMessage);
}
