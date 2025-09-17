import 'package:chat_app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String? value)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String? value)? onChange;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.onChange,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.text30Color),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.text50Color,
        ),
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChange,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
