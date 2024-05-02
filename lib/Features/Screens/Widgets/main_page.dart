

import 'package:a/Features/Screens/Widgets/verification.dart';
import 'package:flutter/material.dart';

import '../../../Constants/dialogues.dart';
import '../../../Constants/enums.dart';
import '../../../Services/auth_service.dart';
import '../../../Services/crud/notes_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

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
                      await AuthService.firebase().logout();
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
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            final user = AuthService.firebase().currentUser;
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (user?.isEmailVerified ?? false) {
                } else {
                  Future.delayed(
                    const Duration(milliseconds: 0),
                    () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EmailVerification(),
                      ));
                    },
                  );
                }
                return const Column(
                  children: [
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
  //
}
