
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../../../Utilities/core/Media_Query.dart';
import '../../../Utilities/core/buttons.dart';
import '../../Screens/screens/login_view.dart';
import 'page_view.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      child: Stack(
        children: [
          CustomPageView(
            pageController: pageController,
          ),
          Visibility(
            visible: pageController!.hasClients
                ? (pageController?.page == 1 ? false : true)
                : true,
            child: Positioned(
              top: Sizing.defaultSize! * 10,
              right: 32,
              child:  TextButton(
                onPressed: (){
                  Get.to(const LoginView() , transition: Transition.rightToLeft , duration:  const Duration(milliseconds: 800));
                },
                child: const  Text
                ("skip",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),)
              ),
            ),
          ),
          Positioned(
              bottom: Sizing.defaultSize! * 18,
              left: Sizing.defaultSize! * 19,
              right: Sizing.defaultSize! * 19,
              child: SmoothPageIndicator(
                controller: pageController!,
                count: 2,
              )),
          Positioned(
            bottom: Sizing.defaultSize! * 10,
            left: Sizing.defaultSize! * 10,
            right: Sizing.defaultSize! * 10,
            child: GeneralButton(
              text: pageController!.hasClients
                  ? (pageController?.page == 1 ? "Get Started" : "Next")
                  : "Next",
              onTap: () {
                if (pageController!.page! < 1) {
                  pageController!.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                } else {
                  Get.to(
                    () => const LoginView(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
