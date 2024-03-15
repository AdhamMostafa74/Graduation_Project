import 'package:a/firebase_options.dart';
import 'package:a/views/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;
import '../Constants/dialogues.dart';

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
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialogue(context);
                    if (shouldLogout) {
                      await FirebaseAuth.instance.signOut();
                      Future.delayed(
                        Duration.zero,
                        () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "Login", (route) => false);
                        },
                      );
                    }
                }
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
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            final user = FirebaseAuth.instance.currentUser;
            user?.reload();
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (user?.emailVerified ?? false) {
                } else {
                  Future.delayed(const Duration(milliseconds: 0) ,() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EmailVerification(),));
                  }, );
                }
                return Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          dev.log((user).toString());
                        },
                        child: const Text("Test"))
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        )
    );
  }
  //
}
