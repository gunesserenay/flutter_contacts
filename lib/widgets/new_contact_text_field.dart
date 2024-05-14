import 'package:flutter/material.dart';

class NewContactTextField extends StatelessWidget {
  const NewContactTextField({
    super.key,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLenght = 50,
    this.validator,
    required this.controller,
  });

  final String hint;
  final TextInputType keyboardType;
  final double maxLenght;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {},
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
      ),
    );
  }
}
