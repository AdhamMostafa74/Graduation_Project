import 'package:a/Constants/routes.dart';
import 'package:a/Constants/dialogues.dart';
import 'package:a/Services/auth_service.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          const Text("Didn't receive a code? Click here."),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
                Future.delayed(
                  const Duration(milliseconds: 3000),
                  () {
                    showVerificationDialogue(context, "Email sent!", "Ok");
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                );
              },
              child: const Text("Send verification.")),
          TextButton(
            onPressed: () {
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                AuthService.firebase().logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              } else {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }
            },
            child: const Text("Already verified? Login here."),
          ),
        ],
      ),
    );
  }
}
