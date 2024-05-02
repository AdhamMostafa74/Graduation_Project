import 'package:a/Constants/routes.dart';
import 'package:a/Services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../Constants/dialogues.dart';
import '../../../Services/auth_exceptions.dart';

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
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
          tooltip: "Menu",
        ),
        title: const Text("Login"),
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
              return Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: ("E-mail")),
                    controller: _email,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(hintText: ("Password")),
                    controller: _password,
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase()
                              .login(email: email, password: password);
                          final user = AuthService.firebase().currentUser;

                          if (user?.isEmailVerified ?? false) {
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainPageRoute, (route) => false);
                            }
                          } else {
                            if (context.mounted) {
                              showRedirectingDialogue(context);
                              Future.delayed(
                                const Duration(milliseconds: 3000),
                                () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      verificationRoute, (route) => false);
                                },
                              );
                            }
                          }
                        } on UserNotFoundAuthException {
                          if (context.mounted) {
                            await showErrorDialogue(context, "User not found");
                          }
                        } on WrongPasswordAuthException {
                          if (context.mounted) {
                            await showErrorDialogue(context, "Wrong Password");
                          }
                        } on GenericAuthAuthException {
                          if (context.mounted) {
                            await showErrorDialogue(
                                context, "Authentication Error");
                          }
                        }
                      },
                      child: const Text("Login")),
                  const Text("OR"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute, (route) => false);
                      },
                      child: const Text("Sign up"))
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
