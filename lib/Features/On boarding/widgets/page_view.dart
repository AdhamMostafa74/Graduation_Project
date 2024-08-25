import 'package:flutter/material.dart';

import 'page_view_item.dart';

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
              "Get A Real Offer For Your Car.\nLicensed, Bonded and Insured.",
          subTitle: "Skip the Dealership, We Come To You!",
          image: "assets/images/onBoardingImages/onboarding1.png",
        ),
        PageViewItem(
          title: "Give Some Information \nAbout Your Vehicle.",
          subTitle: "A Part Of Your Journey!",
          image: "assets/images/onBoardingImages/onboarding2.png",
        )
      ],
    );
  }
}
