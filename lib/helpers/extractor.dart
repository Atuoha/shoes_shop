import 'dart:convert';

String extractString(dynamic json, String extractKeyWord) {
  String status = json['extractKeyWord'].toString();
  return status;
}
