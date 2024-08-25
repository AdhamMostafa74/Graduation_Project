
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
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AColors.mainColor, AColors.mainBlue],
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
                      text: "First name",
                      textEditingController: _firstName,
                      suggestions: true,
                    ),
                    const VerticalSpacer(2),
                    CustomTextField(
                      textInputType: true,
                      obscureText: false,
                      autoCorrect: true,
                      text: "Last name",
                      textEditingController: _lastName,
                      suggestions: true,
                    ),
                    const VerticalSpacer(2),
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
                      width: Sizing.defaultSize! * 35,
                      onTap: () async {
                        final firstName = _firstName.text;
                        final lastNAme = _lastName.text;
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
                        if (password == confirmPassword) {
                          try {
                            await AuthService.firebase().register(
                                email: email,
                                password: password,
                                firstName: firstName,
                                lastName: lastNAme);
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
                        } else {
                          if (context.mounted) {
                            await showErrorDialogue(
                                context, "Password doesn't match!");
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
                              style: TextStyle(
                                  color: AColors.mainColor,
                                  decoration: TextDecoration.underline),
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
