import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? error;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType; // Add keyboardType parameter

  const InputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.error,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.keyboardType, // Initialize keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType, // Set keyboardType
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.4),
              ),
              prefixIcon: icon != null ? Icon(icon) : null,
            ),
            onChanged: onChanged,
            validator: validator,
            minLines: minLines,
            maxLines: maxLines,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              error!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
