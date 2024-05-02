import 'package:a/Utilities/Media_Query.dart';
import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer(this.height, {super.key});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizing.defaultSize! * height!,
    );
  }
}

class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer(this.width, {super.key});
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizing.defaultSize! * width!,
    );
  }
}
