import 'package:a/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

enum MenuAction { logout }

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("MainPage"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){

                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialogue(context);
                       if (shouldLogout){
                       await FirebaseAuth.instance.signOut();
                       Future.delayed(Duration.zero,() {
                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginView(),));
                       },);
                    }
              }

              // switch(value){
              //   case MenuAction.logout:
              //     final shouldLogout = await showLogoutDialogue(context);
              //     dev.log(shouldLogout.toString());
              //     break;
              // }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                )
              ];
            },
          )
        ],
      ),
    );
  }
}
Future<bool> showLogoutDialogue (BuildContext context){
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
    title: const Text("Sign out"),
    content: const Text("Are you sure you want to logout?"),
    actions: [
      TextButton(onPressed: () {
        Navigator.of(context).pop(false);
      }, child: const Text("Cancel")),
      TextButton(onPressed: () {
        Navigator.of(context).pop(true);
      }, child: const Text("Logout"))
    ],
    );
  },).then((value) => value?? false);
}





















// Future<bool> showDialogue(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text("Sign out"),
//         content: const Text("Are you sure you want to LOGOUT? "),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text("Cancel")),
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text("Logout")),
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }
