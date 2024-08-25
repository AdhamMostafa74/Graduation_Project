import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.text,
      required this.textEditingController,
      this.suggestions,
      this.autoCorrect,
      this.textInputType,
      this.obscureText});
  final String? text;
  final TextEditingController textEditingController;
  final bool? suggestions;
  final bool? autoCorrect;
  final bool? obscureText;
  final bool? textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        keyboardType: textInputType == true
            ? TextInputType.emailAddress
            : TextInputType.text,
        autocorrect: autoCorrect!,
        enableSuggestions: suggestions!,
        controller: textEditingController,
        obscureText: obscureText!,
        decoration: InputDecoration(
          hintText: (text),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color:Color(0xffb2b4b3), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xff152238),
              width: 4,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    required this.text,
    required this.textEditingController,
  });
  final String? text;
  final TextEditingController textEditingController;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  late bool _isObscured;
  @override
  void initState() {
    _isObscured = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        autocorrect: false,
        enableSuggestions: false,
        controller: widget.textEditingController,
        obscureText: _isObscured,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: _isObscured == true
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility_rounded)),
          ),

          hintText: (widget.text),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xffb2b4b3), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xff152238),
              width: 4,
            ),
          ),
        ),
      ),
    );
  }
}
