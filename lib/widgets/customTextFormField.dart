import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final bool readOnly;
  final Function? onChanged;
  final Function? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration decoration;
  final TextInputType? textInputType;
  final TextEditingController? controller;

  const CustomTextFormField(
      {super.key,
      required this.readOnly,
      this.onChanged,
      this.validator,
      this.inputFormatters,
      required this.decoration,
      this.textInputType,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          controller: controller,
          enableInteractiveSelection: false,
          readOnly: readOnly,
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          decoration: decoration,
          onChanged: (value) => onChanged != null ? onChanged!(value) : Null,
          validator: (value) => validator != null ? validator!(value) : null),
    );
  }
}
