import 'dart:convert';

import 'package:a/Features/Screens/Widgets/login_view.dart';
import 'package:a/Services/firebase_auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  List apiTest = [];
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  // final bool emailVerified = FirebaseAuthProvider().currentUser.isEmailVerified;
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
                  print(FirebaseAuth.instance.currentUser!);
                  final shouldLogout = await showLogoutDialogue(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logout();
                    Future.delayed(
                      Duration.zero,
                      () {
                        Get.to(() => const LoginView(),
                            transition: Transition.fadeIn);
                      },
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  enabled:
                      FirebaseAuthProvider().currentUser == null ? false : true,
                  value: MenuAction.logout,
                  child: Visibility(
                      visible: FirebaseAuthProvider().currentUser == null
                          ? false
                          : true,
                      child: const Text("Logout")),
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
                // Future.delayed(
                //   const Duration(milliseconds: 0),
                //   () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => const EmailVerification(),
                //     ));
                //   },
                // );
              }
              return const Column(
                children: [],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
  getDataAPI()async{
    http.Response data = await http.get(Uri.parse("http://api.alquran.cloud/v1/quran/ar.alafasy"));
    Map<String, dynamic> body =jsonDecode(data.body);
    if(body.containsKey("data")) {
      apiTest = body["data"]["surahs"];
    }

    setState(() {

    });

  }
}
