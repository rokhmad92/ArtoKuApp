import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormDate extends StatefulWidget {
  const FormDate({
    super.key,
    this.backgroundColor,
    this.borderColor,
    this.borderFocusColor,
    this.suffixIcon,
    this.controller,
    required this.labelText,
    required this.hintText,
  });

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? borderFocusColor;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String labelText;
  final String hintText;

  @override
  State<FormDate> createState() => _FormDateState();
}

class _FormDateState extends State<FormDate> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty || value == '') {
          return 'Form tidak boleh kosong';
        }
        return null;
      },
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
        DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: firstDayOfMonth,
          lastDate: lastDayOfMonth,
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

          setState(() {
            widget.controller!.text = formattedDate;
          });
        }
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon ??
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.calendar_today),
            ),
        filled: true,
        fillColor: widget.backgroundColor ?? Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: widget.borderFocusColor ?? Colors.black,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
