import 'package:flutter/material.dart';

class TextContentCard extends StatelessWidget {
  final String text1;
  final String text2;

  const TextContentCard({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black, // Set the default text color
        ),
        children: [
          TextSpan(
            text: text1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text2,
          ),
        ],
      ),
    );
  }
}
