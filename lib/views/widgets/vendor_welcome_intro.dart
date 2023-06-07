import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/views/widgets/loading_widget.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';


class VendorWelcomeIntro extends StatefulWidget {
  const VendorWelcomeIntro({
    Key? key,
  }) : super(key: key);

  @override
  State<VendorWelcomeIntro> createState() => _VendorWelcomeIntroState();
}

class _VendorWelcomeIntroState extends State<VendorWelcomeIntro> {
  DocumentSnapshot? store;
  bool isLoading = true;

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final firebaseFirestore =  FirebaseFirestore.instance;

  fetchUserDetails()async{
    store = await firebaseFirestore.collection('vendors').doc(userId).get();
    setState(() {
      isLoading = false;
    });

  }


  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }


  @override
  Widget build(BuildContext context) {
    return !isLoading?  Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(store!['storeImgUrl']),
        ),
        const SizedBox(width: 15),
        Text(
          'Hello ${store!['storeName']} 👋',
          style: getRegularStyle(
            color: Colors.black,
            fontSize: FontSize.s16,
          ),
        )
      ],
    ): const LoadingWidget(size:20);
  }
}
