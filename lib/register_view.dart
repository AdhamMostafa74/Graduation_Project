import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

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
              return Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: ("E-mail")
                    ),
                    controller: _email,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: ("Password")
                    ),
                    controller: _password,
                  ),
                  TextButton(onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: email, password: password);
                      print(userCredential);
                    } on FirebaseAuthException catch(e){
                      print(e.code);
                      if ( e.code == "weak-password"){
                        print("Weak Password");
                      }else if (e.code == "email-already-in-use"){
                        print("Email already in use");
                      }else if ( e.code == "invalid-email"){
                        print("Please use a valid Email format");
                      }
                    }

                  },
                      child: const Text("Register")
                  ),
                ],
              );
            default:
              return const Text("Loading ...");
          }
        },
      ),

    );
  }
}


