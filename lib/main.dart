import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Register',
    theme: ThemeData(

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage()
  ));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {}, icon: const Icon(Icons.menu), tooltip: "Menu",),
        title: const Text("Register"),
        actions: const [
          IconButton(
            onPressed: null, icon: Icon(Icons.search), tooltip: "Search",)
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
            final user =  FirebaseAuth.instance.currentUser;
             if (user?.emailVerified??false){
               print(" Your email is verified ");
             }else {
               print("Please verify your email");
             }
             return const Text("Done");
            default:
              return const Text("Loading ...");
          }
        },
      ),

    );
  }
}

