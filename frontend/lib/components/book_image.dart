import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  final String imageUrl;
  final bool? inCard;

  const BookImage({super.key, required this.imageUrl, this.inCard = false});

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.sizeOf(context).width >= 600;
    String image = "assets/images/NoPicture.png";

    return isScreenWide
        ? inCard!
            ? imageUrl != ""
                ? SizedBox(
                    child: Image.network(
                    imageUrl,
                    fit: BoxFit.scaleDown,
                    width: MediaQuery.of(context).size.width,
                  ))
                : SizedBox(
                    child: Image.asset(image,
                        fit: BoxFit.scaleDown,
                        width: MediaQuery.of(context).size.width))
            : imageUrl != ""
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ))
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: Image.asset(image,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width))
        : inCard!
            ? imageUrl != ""
                ? SizedBox(
                    child: Image.network(imageUrl,
                        fit: BoxFit.scaleDown,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center))
                : SizedBox(
                    child: Image.asset(image,
                        fit: BoxFit.scaleDown,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center))
            : imageUrl != ""
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.network(imageUrl,
                        fit: BoxFit.scaleDown,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft))
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset(image,
                        fit: BoxFit.scaleDown,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft));
  }
}
