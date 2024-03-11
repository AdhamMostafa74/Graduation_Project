import 'package:a/Constants/routes.dart';
import 'package:a/views/login_view.dart';
import 'package:a/views/main_page.dart';
import 'package:a/views/register_view.dart';
import 'package:a/views/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      home: const LoginView(),
      routes: {
        loginRoute:(context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        mainPageRoute: (context) => const MainPage(),
        verificationRoute: (context) => const EmailVerification(),
      },
  ))

  ;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
          tooltip: "Menu",
        ),
        title: const Text("Verified"),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search),
            tooltip: "Search",
          )
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
              } else {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EmailVerification(),
                  ));
                });
              }
              return  Column(
                children: [
                  const Text("Done"),
                  TextButton(onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);

                  }, child:const Text("Login"))
                ],
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
