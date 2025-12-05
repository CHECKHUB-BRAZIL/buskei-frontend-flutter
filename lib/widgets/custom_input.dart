import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final IconData? icon;

  const CustomInput({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),

      ),

      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Color(0xFF1B1E28)),
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.black54)
              : null,
        ),
      ),
    );
  }
}
