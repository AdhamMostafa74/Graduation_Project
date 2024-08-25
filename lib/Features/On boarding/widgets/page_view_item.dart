import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/core/Media_Query.dart';
import '../../../Utilities/core/space_Widget.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({super.key, this.title, this.subTitle, this.image});
  final String? title;
  final String? subTitle;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Column(
          children: [
            const VerticalSpacer(25),
            SizedBox(
              height: Sizing.defaultSize! * 22,
              child: Image.asset(image!),
            ),
            const VerticalSpacer(2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const VerticalSpacer(3),
                Text(
                  subTitle!,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
