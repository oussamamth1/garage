import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garage_management/src/theme/app_theme.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;
  final bool hasImage;

  const AppGradientBackground({
    super.key,
    required this.child,
    this.hasImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundOverlay,
            AppColors.backgroundOverlayDark,
          ],
        ),
      ),
      child: child,
    );
  }
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final List<String>? autofillHints;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: AppColors.inputText, fontSize: 16),
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autofillHints: autofillHints,
      decoration: InputDecoration(hintText: hintText),
      validator: validator,
    );
  }
}

class AppRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String label;

  const AppRadioButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primaryGold : Colors.transparent,
              border: Border.all(color: AppColors.primaryGold, width: 2),
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: AppColors.textBlack,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AppProfileImagePicker extends StatelessWidget {
  final File? pickedImage;
  final VoidCallback onTap;
  final double radius;

  const AppProfileImagePicker({
    super.key,
    required this.pickedImage,
    required this.onTap,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: AppColors.primaryGold,
              shape: BoxShape.circle,
              image: pickedImage != null
                  ? DecorationImage(
                      image: FileImage(pickedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: pickedImage == null
                ? Icon(
                    Icons.add_a_photo,
                    size: radius * 0.8,
                    color: AppColors.textWhite.withOpacity(0.7),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to add profile photo',
          style: TextStyle(color: AppColors.textWhite60, fontSize: 12),
        ),
      ],
    );
  }
}
