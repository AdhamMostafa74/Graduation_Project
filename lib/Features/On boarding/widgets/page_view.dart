import 'package:a/Features/On%20boarding/widgets/page_view_item.dart';
import 'package:flutter/material.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView({super.key, @required this.pageController});

  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller:  pageController,
      children: const [
        PageViewItem(
          title:
              "Get a real offer for your car.\nLicensed, Bonded and Insured.",
          subTitle: "Skip the Dealership, We Come To You!",
          image: "assets/images/onboarding1.png",
        ),
        PageViewItem(
          title: "Give Some Information \nAbout Your Vehicle.",
          subTitle: "A Part Of Your Journey!",
          image: "assets/images/onboarding2.png",
        )
      ],
    );
  }
}
