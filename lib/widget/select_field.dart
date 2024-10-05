import 'package:flutter/material.dart';

class FormSelect extends StatefulWidget {
  const FormSelect(
      {super.key, required this.list, required this.onChanged, this.value});
  final List<String> list;
  final ValueChanged<String?> onChanged;
  final String? value;

  @override
  State<FormSelect> createState() => _FormSelectState();
}

class _FormSelectState extends State<FormSelect> {
  late String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        widget.value ?? (widget.list.isNotEmpty ? widget.list.first : '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          isExpanded: true,
          value: dropdownValue,
          items: widget.list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue;
            });
            widget.onChanged(newValue);
          },
        ),
      ),
    );
  }
}
