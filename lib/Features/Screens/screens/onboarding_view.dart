import 'package:flutter/material.dart';

import '../../On boarding/widgets/onboarding_body.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  OnBoardingViewBody(),
    );
  }
}
