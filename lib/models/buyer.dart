import 'package:cloud_firestore/cloud_firestore.dart';

class Buyer {
  final String customerId;
  final String fullname;
  final String image;
  final String email;
  final String phone;
  final String address;

  Buyer({
    required this.customerId,
    required this.fullname,
    required this.image,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Buyer.initial() => Buyer(
        customerId: '',
        fullname: '',
        email: '',
        image: '',
        phone: '',
        address: '',
      );

  Buyer.fromJson(DocumentSnapshot data)
      : this(
          customerId: data['customerId'],
          fullname: data['fullname'],
          image: data['image'],
          email: data['email'],
          phone: data['phone'],
          address: data['address'],
        );
}
