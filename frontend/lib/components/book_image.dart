import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  final String imageUrl;

  const BookImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.sizeOf(context).width >= 600;
    return isScreenWide
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            height: MediaQuery.of(context).size.height * 0.60,
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
              
            ))
        : SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.network(imageUrl,
                fit: BoxFit.scaleDown,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft));
  }
}
