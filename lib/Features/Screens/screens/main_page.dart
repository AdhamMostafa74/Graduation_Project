//
// import 'package:a/Features/Screens/Widgets/login_view.dart';
// import 'package:a/Services/firebase_auth_providers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// import '../../../Constants/dialogues.dart';
// import '../../../Constants/enums.dart';
// // import '../../../Services/crud/notes_service.dart';
// import 'package:a/Constants/colors.dart';
// import 'package:a/Utilities/Media_Query.dart';
// import 'package:a/Utilities/icon_button.dart';
// import 'package:a/Utilities/nav_bar_item.dart';
// import 'package:a/Utilities/space_Widget.dart';
// import 'package:iconsax/iconsax.dart';

import 'package:a/Utilities/constants/text_strings.dart';
import 'package:a/Features/widgets/appbar_widgets/custom_appbar.dart';
import 'package:a/Features/widgets/navigation_menus/home.dart';
import 'package:a/Features/widgets/navigation_menus/navigation_menu.dart';
import 'package:a/Utilities/helpers/pricing_calculator.dart';
import 'package:get/get.dart';

import '../../../Services/firebase_services/auth_service.dart';
import 'package:flutter/material.dart';
//
// import '../../../Utilities/nav_bar_item.dart';
// import '../../../navigation_menu.dart';
// // import '../../On boarding/widgets/app_bar_content.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  // final bool emailVerified = FirebaseAuthProvider().currentUser.isEmailVerified;
  final controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        final user = AuthService.firebase().currentUser;
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return NavigationMenu();

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
