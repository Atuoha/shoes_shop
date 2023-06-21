class Customer {
  final String customerId;
  final String fullname;
  final String image;
  final String email;
  final String phone;
  final String address;

  Customer({
    required this.customerId,
    required this.fullname,
    required this.image,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Customer.initial() => Customer(
    customerId: '',
        fullname: '',
        email: '',
        image: '',
        phone: '',
        address: '',
      );
}
