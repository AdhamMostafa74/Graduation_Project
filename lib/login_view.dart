import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:a/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        leading: IconButton(onPressed: () {
        }, icon: const Icon(Icons.menu),tooltip: "Menu",),
        title: const Text("Login"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.search) , tooltip: "Search",)
        ],

        backgroundColor: Colors.blueAccent,

      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options:  DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {

          switch (snapshot.connectionState){
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
                    controller:  _password,
                  ),
                  TextButton (onPressed: () async{
                    final email = _email.text;
                    final password = _password.text;
                    try{
                      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                      print(userCredential);
                    }
                    on FirebaseAuthException catch (e) {
                      if (e.code == "invalid-credential"){
                        print("User not found");
                      }else{
                        print ("Something unusual happened! ");
                        print (e.code);
                      }
                   }
                    },
                      child: const Text("Login")
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
