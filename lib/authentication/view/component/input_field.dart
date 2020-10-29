import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  TextInputType textInputType;
  bool obscureText;

  InputField({
    Key key,
    @required this.controller,
    @required this.label,
    this.textInputType= TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 4.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        labelText: label,
        hintStyle: TextStyle(color: Colors.grey),
        prefixText: ' ',
      ),
    );
  }
}
