import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  const FormText(
      {super.key,
      this.prefixIcon,
      this.backgroundColor,
      this.borderColor,
      this.borderFocusColor,
      this.suffixIcon,
      this.inputActionDone = false,
      this.border = true,
      required this.labelText,
      required this.hintText,
      this.controller,
      this.obscureText = false,
      this.required = true,
      this.textKapital = true});

  final Icon? prefixIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? borderFocusColor;
  final GestureDetector? suffixIcon;
  final bool? border;
  final bool? textKapital;
  final bool? required;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final bool inputActionDone;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (required == true && (value == null || value.isEmpty)) {
          return 'Form tidak boleh kosong';
        }

        return null;
      },
      controller: controller,
      obscureText: obscureText,
      textCapitalization:
          textKapital! ? TextCapitalization.sentences : TextCapitalization.none,
      textInputAction:
          inputActionDone ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: suffixIcon,
        ),
        filled: true,
        fillColor: backgroundColor ?? Colors.transparent,
        border: border == true
            ? OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide:
                    BorderSide(color: borderColor ?? Colors.black, width: 1.0),
              )
            : null,
        focusedBorder: border == true
            ? OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                    color: borderFocusColor ?? Colors.black, width: 2.0),
              )
            : null,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
