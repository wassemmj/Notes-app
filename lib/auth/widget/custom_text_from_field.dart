import 'package:flutter/material.dart';

class CustomTextFromField extends StatelessWidget {
  const CustomTextFromField({super.key, required this.controller, required this.text, required this.validator});

  final TextEditingController controller ;
  final String text ;
  final String? Function(String?) validator ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Enter your email",
            hintStyle: const TextStyle(
              color: Colors.black38,
              fontSize: 18,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black45,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black12,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
