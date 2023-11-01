import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.hintText,
      this.onChanged,
      this.obscureText = false});
  final String hintText;
  final Function(String)? onChanged;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'The field cannot be empty';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      obscureText: obscureText!,
    );
  }
}
