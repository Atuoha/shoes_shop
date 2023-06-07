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

  Vendor.fromJson(Map<String, dynamic> data)
      : this(
          storeId: data['storeId'] as String,
          storeName: data['storeName'] as String,
          email: data['email'] as String,
          phone: data['phone'] as String,
          taxNumber: data['taxNumber']! as String,
          storeNumber: data['storeNumber']! as String,
          country: data['country'] as String,
          state: data['state'] as String,
          city: data['city'] as String,
          address: data['address'] as String,
          authType: data['authType'] as String,
          storeImgUrl: data['storeImgUrl'] as String,
          isApproved: data['isApproved'] as bool,
          isStoreRegistered: data['isStoreRegistered'] as bool,
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
