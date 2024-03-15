import 'package:a/Constants/routes.dart';
import 'package:a/Constants/dialogues.dart';
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
          const Text("Please verify your Email"),
          TextButton(
              onPressed: () async {
                await showVerificationDialogue(context, "Email sent!", "Ok");
                Future.delayed(
                  const Duration(milliseconds: 3000),
                  () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                );
              },
              child: const Text("Send verification ")),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already verified ? Login here"),
          ),
        ],
      ),
    );
  }
}
