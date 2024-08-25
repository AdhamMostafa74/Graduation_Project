import 'package:flutter/material.dart';

import 'Media_Query.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key,required this.iconData});
  final IconData? iconData;
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 30,
      width: Sizing.defaultSize!*5,
       decoration: BoxDecoration(borderRadius: BorderRadius.circular(85),color: Colors.grey,),
      child: Icon(iconData),
    );
  }
}
