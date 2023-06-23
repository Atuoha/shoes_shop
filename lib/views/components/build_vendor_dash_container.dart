import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../vendor/main_screen.dart';

class BuildDashboardContainer extends StatelessWidget {
  BuildDashboardContainer({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.index = 0,
    this.isBtn = true,
  }) : super(key: key);
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  int index;
  bool isBtn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      child: FittedBox(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(
                            fontSize: FontSize.s14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      value,
                      style: getBoldStyle(
                        fontSize: FontSize.s16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(icon, color: accentColor, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            isBtn
                ? ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            VendorMainScreen(index: index), // Todo: add index
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        'view more',
                        style: getRegularStyle(color: accentColor),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
