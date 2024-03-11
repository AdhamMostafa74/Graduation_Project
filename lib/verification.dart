import 'package:a/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar:AppBar(
        title: const Text("Verification"),
      ),
      body: Column(
        children: [
          const Text("Please verify your Email"),
          TextButton(onPressed: () async {

            final user =  FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            Future.delayed(Duration.zero,() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginView(),));
            },);
          }, child: const Text("Send verification ") )
        ],
      ),
    );
  }
}