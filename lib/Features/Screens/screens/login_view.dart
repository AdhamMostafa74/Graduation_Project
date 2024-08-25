
import 'package:a/Features/Screens/screens/register_view.dart';
import 'package:a/Features/Screens/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/dialogues.dart';
import '../../../Services/firebase_services/auth_exceptions.dart';
import '../../../Services/firebase_services/auth_service.dart';
import '../../../Utilities/core/Media_Query.dart';
import '../../../Utilities/core/buttons.dart';
import '../../../Utilities/core/space_Widget.dart';
import '../../widgets/texts/text_fields.dart';
import '../../On boarding/widgets/app_bar_content.dart';
import 'main_page.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AColors.mainColor, AColors.mainBlue],
          )),
          child: const AppBarContent(text: "Login",),
        ),
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const VerticalSpacer(5),
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
                  const VerticalSpacer(3),
                  GeneralButton(
                    onTap: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase()
                            .login(email: email, password: password);
                        final user = AuthService.firebase().currentUser;

                        if (user?.isEmailVerified ?? false) {
                          if (context.mounted) {
                            Get.to(() => const MainPage(),
                                transition: Transition.fadeIn);
                          }
                        } else {
                          if (context.mounted) {
                            showRedirectingDialogue(context);
                            Future.delayed(
                              const Duration(milliseconds: 3000),
                              () {
                                Get.to(() => const EmailVerification(),
                                    transition: Transition.fadeIn);
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
                    text: ("Login"),
                    width: Sizing.defaultSize! * 35,
                  ),
                  const VerticalSpacer(1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HorizontalSpacer(Sizing.defaultSize!),
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const RegisterView(),
                                transition: Transition.fadeIn);
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(color: AColors.mainColor, decoration: TextDecoration.underline),

                          )),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const MainPage(),
                          transition: Transition.fadeIn);
                    },
                    child: const Text(
                      "Continue as a Guest",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black , decoration:  TextDecoration.underline),
                    ),
                  )
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
