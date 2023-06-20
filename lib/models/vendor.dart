class Vendor {
  final String storeId;
  final String storeName;
  final String email;
  final String phone;
  final String? taxNumber;
  final String? storeNumber;
  final String country;
  final String state;
  final String city;
  final String storeImgUrl;
  final String? address;
  final String authType;
  bool isApproved;
  bool isStoreRegistered;

  Vendor({
    required this.storeId,
    required this.storeName,
    required this.email,
    required this.phone,
    required this.taxNumber,
    required this.storeNumber,
    required this.country,
    required this.state,
    required this.city,
    required this.storeImgUrl,
    required this.address,
    required this.authType,
    this.isApproved = false,
    this.isStoreRegistered = false,
  });

  factory Vendor.initial() => Vendor(
        storeId: '',
        storeName: '',
        email: '',
        phone: '',
        taxNumber: '',
        storeNumber: '',
        country: '',
        state: '',
        city: '',
        storeImgUrl: '',
        address: '',
        authType: '',
      );

  Vendor.fromJson(Map<String, dynamic> data)
      : this(
          storeId: data['storeId'],
          storeName: data['storeName'],
          email: data['email'],
          phone: data['phone'],
          taxNumber: data['taxNumber'],
          storeNumber: data['storeNumber'],
          country: data['country'],
          state: data['state'],
          city: data['city'],
          address: data['address'],
          authType: data['authType'],
          storeImgUrl: data['storeImgUrl'],
          isApproved: data['isApproved'],
          isStoreRegistered: data['isStoreRegistered'],
        );

  Map<String, dynamic> toJson() => {
        'storeId': storeId,
        'storeName': storeName,
        'email': email,
        'phone': phone,
        'taxNumber': taxNumber,
        'storeNumber': storeNumber,
        'country': country,
        'state': state,
        'city': city,
        'address': address,
        'authType': authType,
        'storeImgUrl': storeImgUrl,
        'isStoreRegistered': isStoreRegistered,
        'isApproved': isApproved,
      };
}
