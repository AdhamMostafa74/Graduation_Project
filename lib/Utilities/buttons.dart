import 'package:a/Constants/Colors.dart';
import 'package:a/Utilities/Media_Query.dart';
import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  const GeneralButton({super.key, this.text, this.onTap});
  final String? text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: Sizing.defaultSize,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: mainColor,
        ),
        child:  Center(
          child: Text(
            text!,
            style: const TextStyle(color: Colors.white , fontSize: 20),
          ),
        ),
      ),
    );
  }
}
