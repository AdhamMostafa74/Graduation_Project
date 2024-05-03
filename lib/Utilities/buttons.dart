import 'package:a/Constants/colors.dart';
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
        width: 325,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: mainColor,
        ),
        child:  Center(
          child: Text(
            text!,
            style: const TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
