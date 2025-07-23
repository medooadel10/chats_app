import 'package:chats_app/core/style/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIcon;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.onSuffixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: const Color(0xffFDFDFF),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.text30Color),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.text30Color),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
        suffixIcon: IconButton(onPressed: onSuffixIcon, icon: Icon(suffixIcon)),
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
