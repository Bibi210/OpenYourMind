import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, 
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.sizeOf(context).width >= 600;
    return ElevatedButton(
      onPressed: onPressed,
      style : ButtonStyle(
        minimumSize: isScreenWide ?  MaterialStateProperty.all<Size>(const Size(200, 50)): null,
        alignment: AlignmentDirectional.center,
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.secondary),),
      child: Text(text),
    );
  }
}
