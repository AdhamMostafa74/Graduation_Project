import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../../Constants/colors.dart';

class CustomDotsIndicator extends StatelessWidget {
  const CustomDotsIndicator({super.key, @required this.dotPosition});
  final int? dotPosition;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: 2,
      position: dotPosition!,
      decorator: DotsDecorator(
        color: Colors.transparent,
        activeColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: mainColor),
        ),
      ),
    );
  }
}
