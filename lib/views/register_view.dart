import 'package:a/Constants/routes.dart';
import 'package:a/Constants/dialogues.dart';
import 'package:a/Services/auth_exceptions.dart';
import 'package:a/Services/auth_service.dart';
import 'package:flutter/material.dart';

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
          onPressed: () {},
          icon: const Icon(Icons.menu),
          tooltip: "Menu",
        ),
        title: const Text("Register"),
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
                        await AuthService.firebase().sendEmailVerification();
                        try {
                          await AuthService.firebase()
                              .register(email: email, password: password);
                          await AuthService.firebase()
                              .login(email: email, password: password);

                          Future.delayed(Duration.zero, () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                verificationRoute, (route) => false);
                          });
                        } on WeakPasswordAuthException {
                          if (context.mounted) {
                            await showErrorDialogue(context, "Weak Password");
                          }
                        } on EmailAlreadyInUserAuthException {
                          if (context.mounted) {
                            await showErrorDialogue(
                                context, "Email already in use.");
                          }
                        } on InvalidEmailAuthException {
                          {
                            if (context.mounted) {
                              await showErrorDialogue(
                                  context, "Invalid email.");
                            }
                          }
                        } on GenericAuthAuthException {
                          if (context.mounted) {
                            await showErrorDialogue(context, "Unknown Error");
                          }
                        }
                      },
                      child: const Text("Register")),
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
