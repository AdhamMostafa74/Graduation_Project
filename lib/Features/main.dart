import 'dart:io';

import 'package:a/Presentation/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import '../Constants/routes.dart';
import '../Services/auth_service.dart';
import 'Screens/Widgets/login_view.dart';
import 'Screens/Widgets/main_page.dart';
import 'Screens/Widgets/register_view.dart';
import 'Screens/Widgets/verification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Register',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const SplashScreen(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      mainPageRoute: (context) => const MainPage(),
      verificationRoute: (context) => const EmailVerification(),
    },
  ));
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
        title: const Text("Loading"),
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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  Future.delayed(
                    const Duration(milliseconds: 0),
                    () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          mainPageRoute, (route) => false);
                    },
                  );
                } else {
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmailVerification(),
                    ));
                  });
                }
              } else {
                Future.delayed(
                  const Duration(milliseconds: 1200),
                  () {
                    Navigator.of(context).pushNamed(loginRoute);
                  },
                );
              }
              return const CircularProgressIndicator();

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}