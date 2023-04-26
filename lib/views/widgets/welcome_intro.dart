import 'package:flutter/material.dart';

import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';


class WelcomeIntro extends StatelessWidget {
  const WelcomeIntro({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage(AssetManager.profileImg),
        ),
        const SizedBox(width: 15),
        Text(
          'Hello Ujunwa 👋',
          style: getRegularStyle(
            color: Colors.black,
            fontSize: FontSize.s16,
          ),
        )
      ],
    );
  }
}
