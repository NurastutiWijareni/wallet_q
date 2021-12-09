import 'package:flutter/material.dart';

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    required this.title,
    required this.text,
    required this.image,
  });
  final String? title, text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Spacer(),
        Image.asset(
          image!,
          // width: double.infinity,
          height: MediaQuery.of(context).size.height / 3,
          fit: BoxFit.contain,
        ),
        Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
