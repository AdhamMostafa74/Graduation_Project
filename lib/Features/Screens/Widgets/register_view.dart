import 'package:a/Constants/dialogues.dart';
import 'package:a/Features/Screens/Widgets/login_view.dart';
import 'package:a/Features/Screens/Widgets/verification.dart';
import 'package:a/Services/auth_exceptions.dart';
import 'package:a/Services/auth_service.dart';
import 'package:a/Utilities/buttons.dart';
import 'package:a/Utilities/space_Widget.dart';
import 'package:a/Utilities/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Constants/colors.dart';
import '../../../Utilities/Media_Query.dart';
import '../../On boarding/widgets/app_bar_content.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

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
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [mainColor, mainBlue],
          )),
          child: const AppBarContent(
            text: "Create your Account",
          ),
        ),
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    CustomTextField(
                      textInputType: true,
                      obscureText: false,
                      autoCorrect: true,
                      text: "email",
                      textEditingController: _email,
                      suggestions: true,
                    ),
                    const VerticalSpacer(2),
                    CustomPasswordField(
                      text: "Password",
                      textEditingController: _password,
                    ),
                    const VerticalSpacer(2),
                    CustomPasswordField(
                      text: "Confirm password",
                      textEditingController: _confirmPassword,
                    ),
                    const VerticalSpacer(2),
                    GeneralButton(
                      onTap: () async {
                        final email = _email.text;
                        final password = _password.text;
                        final confirmPassword = _confirmPassword.text;
                        final user = AuthService.firebase().currentUser;
                        if (user != null) {
                          if (user.isEmailVerified) {
                            await AuthService.firebase()
                                .sendEmailVerification();
                          }
                        }
                        if(password == confirmPassword){
                          try {
                            await AuthService.firebase()
                                .register(email: email, password: password);
                            Future.delayed(Duration.zero, () {
                              Get.to(() => const EmailVerification(),
                                  transition: Transition.fadeIn);
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
                        }else {
                          if(context.mounted){
                            await showErrorDialogue(context, "Password doesn't match!");
                          }
                        }
                      },
                      text: "Register",
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HorizontalSpacer(Sizing.defaultSize!),
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              Get.to(() => const LoginView(),
                                  transition: Transition.fadeIn);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: mainColor , decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                  ],
                ),
              );
            default:
              return const Text("Loading ...");
          }
        },
      ),
    );
  }
}
