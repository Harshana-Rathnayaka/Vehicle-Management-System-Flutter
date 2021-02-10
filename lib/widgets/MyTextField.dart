import 'package:flutter/material.dart';
import 'package:vehicle_management_system/constants/colors.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final bool isSecure;
  var isPassword;
  final bool isEmail;
  final bool isNumber;
  final bool isMultiline;
  final bool isEnabled;
  final TextEditingController controller;
  final String hint;
  final maxLength;
  final maxLines;
  final validation;
  IconData icon;
  var onChanged;

  MyTextField(
      {this.isPassword = false,
      this.isEmail = false,
      this.isNumber = false,
      this.isMultiline = false,
      this.isSecure = false,
      this.isEnabled = true,
      @required this.controller,
      this.hint = "",
      this.maxLength,
      this.maxLines = 1,
      @required this.validation,
      this.icon,
      this.onChanged});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: TextFormField(
        enabled: widget.isEnabled,
        cursorColor: primaryColor,
        maxLines: widget.maxLines,
        validator: widget.validation,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        controller: widget.controller,
        obscureText: widget.isPassword,
        keyboardType: widget.isEmail
            ? TextInputType.emailAddress
            : (widget.isNumber
                ? TextInputType.number
                : (widget.isMultiline
                    ? TextInputType.multiline
                    : TextInputType.text)),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.teal[100],
          labelText: widget.hint,
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
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: primaryColor,
                )
              : null,
          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.blueGrey[700]),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}
