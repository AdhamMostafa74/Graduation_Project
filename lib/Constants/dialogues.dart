import 'package:a/Constants/routes.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialogue(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("An error occurred"),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      );
    },
  );
}

Future<bool> showLogoutDialogue(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Logout"))
        ],
      );
    },
  ).then((value) => value ?? false);
}

Future<bool> showVerificationDialogue(
    BuildContext context, String text, String button) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Verification sent!"),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(verificationRoute);
              },
              child: Text(button))
        ],
      );
    },
  ).then((value) => value ?? false);
}

Future<bool> showRedirectingDialogue(
    BuildContext context, ) {
  return showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(
        title:  Text("Oops"),
        content: Text("You need to verify your email first!"),
      );
    },
  ).then((value) => value ?? false);
}
