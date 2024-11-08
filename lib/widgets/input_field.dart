import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? error;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;

  const InputField({
    super.key,
    this.labelText,
    this.hintText,
    this.icon,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.error,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.keyboardType,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? !_isPasswordVisible : false,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              alignLabelWithHint: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.4),
              ),
              prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
            onChanged: widget.onChanged,
            validator: widget.validator,
            minLines: widget.isPassword ? 1 : widget.minLines,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              widget.error!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
