import 'package:flutter/material.dart';

class CustomRegisterButton extends StatelessWidget {
  const CustomRegisterButton(
      {super.key,
      required this.txt,
      required this.txtBtn,
      required this.onTap});
  final String txt;
  final String txtBtn;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          txt,
          style: const TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            txtBtn,
            style: const TextStyle(color: Color(0xffc7ede6)),
          ),
        ),
      ],
    );
  }
}
