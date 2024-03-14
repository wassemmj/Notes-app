import 'package:flutter/material.dart';

class PasswordFromField extends StatefulWidget {
  const PasswordFromField({super.key, required this.controller, required this.text, required this.validator});

  final String text ;
  final TextEditingController controller ;
  final String? Function(String?) validator ;

  @override
  State<PasswordFromField> createState() => _PasswordFromFieldState();
}

class _PasswordFromFieldState extends State<PasswordFromField> {

  bool obscure = true ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Enter your password",
            hintStyle: const TextStyle(
              color: Colors.black38,
              fontSize: 18,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => obscure = !obscure),
              icon:
              Icon(obscure ? Icons.visibility : Icons.visibility_off),
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
          controller: widget.controller,
          obscureText: obscure,
          validator: widget.validator,
        ),
      ],
    );
  }
}
