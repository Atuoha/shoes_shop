import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/views/widgets/loading_widget.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';


class WelcomeIntro extends StatefulWidget {
  const WelcomeIntro({
    Key? key,
  }) : super(key: key);

  @override
  State<WelcomeIntro> createState() => _WelcomeIntroState();
}

class _WelcomeIntroState extends State<WelcomeIntro> {
  DocumentSnapshot? profile;
  bool isLoading = true;

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final firebaseFirestore =  FirebaseFirestore.instance;

  fetchUserDetails()async{
    profile = await firebaseFirestore.collection('customers').doc(userId).get();
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
          backgroundImage: NetworkImage(profile!['image']),
        ),
        const SizedBox(width: 15),
        Text(
          'Hello ${profile!['fullname']} 👋',
          style: getRegularStyle(
            color: Colors.black,
            fontSize: FontSize.s16,
          ),
        )
      ],
    ): const LoadingWidget(size:20);
  }
}
