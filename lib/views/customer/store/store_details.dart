import 'package:flutter/material.dart';

import '../../../models/vendor.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key,required this.vendor});
  final Vendor vendor;

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
