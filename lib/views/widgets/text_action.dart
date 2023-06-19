import 'package:flutter/material.dart';

import '../../constants/enums/yes_no.dart';

Widget textAction(String text, YesNo operation, BuildContext context) {
  return ElevatedButton(
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    onPressed: () {
      switch (operation) {
        case YesNo.no:
          Navigator.of(context).pop(false);
          break;
        case YesNo.yes:
          Navigator.of(context).pop(true);
          break;
        default:
      }
    },
  );
}