import 'package:flutter/material.dart';

class TextLine extends StatelessWidget {
  const TextLine({super.key, required this.text});

  final String text ;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
