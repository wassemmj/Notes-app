import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(20),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: const DecorationImage(
          image: AssetImage("assets/logo1.jpg"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
