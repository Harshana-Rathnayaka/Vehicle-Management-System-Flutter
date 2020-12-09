import 'package:flutter/material.dart';
import 'package:vehicle_management_system/constants/colors.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final double width;
  final bool isSecure;
  var isPassword;
  final bool isEmail;
  final bool isNumber;
  final bool isMultiline;
  final TextEditingController controller;
  final String hint;
  final maxLength;
  final maxLines;
  final validation;
  IconData icon;
  var onChanged;

  MyTextField(
      {this.width,
      this.isPassword = false,
      this.isEmail = false,
      this.isNumber = false,
      this.isMultiline = false,
      this.isSecure = false,
      this.controller,
      this.hint = "",
      this.maxLength,
      this.maxLines = 1,
      this.validation,
      this.icon,
      this.onChanged});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.teal[100], borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        maxLines: widget.maxLines,
        obscureText: widget.isPassword,
        keyboardType: widget.isEmail
            ? TextInputType.emailAddress
            : widget.isNumber
                ? TextInputType.number
                : widget.isMultiline
                    ? TextInputType.multiline
                    : TextInputType.text,
        validator: widget.validation,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        cursorColor: primaryColor,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.isSecure
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isPassword = !widget.isPassword;
                    });
                  },
                  child: new Icon(
                    widget.isPassword ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                )
              : null,
          icon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: primaryColor,
                )
              : null,
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.blueGrey[700]),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
