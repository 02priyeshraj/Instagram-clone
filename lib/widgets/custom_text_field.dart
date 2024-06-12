import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class CustomTextFieldContainer extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final bool isFocused;
  final bool isPass;
  final TextInputType textInputType;

  const CustomTextFieldContainer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    required this.isFocused,
    this.isPass = false,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextField(
          style: const TextStyle(
            fontSize: 18.0,
            color: blackColor,
          ),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon,
              color: isFocused ? blackColor : secondaryColor,
            ),
            contentPadding: const EdgeInsets.all(15.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: secondaryColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: blackColor,
                width: 2.0,
              ),
            ),
            filled: true,
          ),
          obscureText: isPass,
          keyboardType: textInputType,
        ),
      ),
    );
  }
}
