// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  CustomBtn({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: const Color(0xFF6a5bc2)),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
