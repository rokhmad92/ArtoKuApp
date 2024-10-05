import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';

class FormNumber extends StatelessWidget {
  const FormNumber({
    super.key,
    this.prefixIcon,
    this.backgroundColor,
    this.borderColor,
    this.borderFocusColor,
    this.suffixIcon,
    this.inputActionDone = false,
    this.currency = false,
    this.controller,
    required this.labelText,
    required this.hintText,
  });

  final Icon? prefixIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? borderFocusColor;
  final GestureDetector? suffixIcon;
  final TextEditingController? controller;
  final bool inputActionDone;
  final bool currency;
  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Form tidak boleh kosong';
        }
        return null;
      },
      textInputAction:
          inputActionDone ? TextInputAction.done : TextInputAction.next,
      inputFormatters: currency
          ? [
              CurrencyTextInputFormatter.currency(
                locale: 'id',
                decimalDigits: 0,
                symbol: 'Rp. ',
              ),
            ]
          : [
              FilteringTextInputFormatter.digitsOnly,
            ],
      keyboardType: TextInputType.number,
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
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: borderColor ?? Colors.black, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: borderFocusColor ?? Colors.black, width: 2.0),
        ),
      ),
    );
  }
}
