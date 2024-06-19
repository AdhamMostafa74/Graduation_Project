//
// import 'package:a/Features/Screens/Widgets/login_view.dart';
// import 'package:a/Services/firebase_auth_providers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// import '../../../Constants/dialogues.dart';
// import '../../../Constants/enums.dart';
// import '../../../Services/crud/notes_service.dart';
import 'package:a/Utilities/Media_Query.dart';
import 'package:a/Utilities/icon_button.dart';
import 'package:a/Utilities/space_Widget.dart';

import '../../../Services/auth_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  // final bool emailVerified = FirebaseAuthProvider().currentUser.isEmailVerified;
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blueAccent,
      //   title: const Text("MainPage"),
      //   actions: [
      //     PopupMenuButton<MenuAction>(
      //       onSelected: (value) async {
      //         switch (value) {
      //           case MenuAction.logout:
      //             final shouldLogout = await showLogoutDialogue(context);
      //             if (shouldLogout) {
      //               await AuthService.firebase().logout();
      //               Future.delayed(
      //                 Duration.zero,
      //                 () {
      //                   Get.to(() => const LoginView(),
      //                       transition: Transition.fadeIn);
      //                 },
      //               );
      //             }
      //         }
      //       },
      //       itemBuilder: (context) {
      //         return [
      //           PopupMenuItem<MenuAction>(
      //             enabled:
      //                 FirebaseAuthProvider().currentUser == null ? false : true,
      //             value: MenuAction.logout,
      //             child: Visibility(
      //                 visible: FirebaseAuthProvider().currentUser == null
      //                     ? false
      //                     : true,
      //                 child: const Text("Logout")),
      //           )
      //         ];
      //       },
      //     )
      //   ],
      // ),

      body:FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          final user = AuthService.firebase().currentUser;
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (user?.isEmailVerified ?? false) {
              } else {
                // Future.delayed(
                //   const Duration(milliseconds: 0),
                //   () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => const EmailVerification(),
                //     ));
                //   },
                // );
              }
              return  SafeArea(
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 20.0),
                    child: Row(
                      children: [
                        const CustomIconButton(iconData: Icons.menu,),
                        HorizontalSpacer(Sizing.defaultSize!*2.5),
                        Row(
                          children: [
                            const CustomIconButton(iconData: Icons.search_rounded,),

                          ],
                        )

                      ],
                    ),
                  )
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),

    );
  }
}
