import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String suffixIcon;
  final bool isCalender;
  final void Function()? onTap;
  final bool isNumber;
  final String? Function(String?)? validator;
  final bool isEditPage;
  TextEditingController? controller;

  CustomTextField(
      {required this.hintText,
      this.suffixIcon = "",
      this.onTap,
      this.controller,
      this.isCalender = false,
      this.isNumber = false,
      this.validator,
      this.isEditPage = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: isNumber ? TextInputType.number : TextInputType.name,
      controller: controller,
      focusNode: isCalender || isEditPage ? AlwaysDisabledFocusNode() : null,
      onTap: onTap,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      decoration: InputDecoration(
        //isDense: true,
        contentPadding: EdgeInsets.only(top: 20),
        suffixIcon: suffixIcon == ""
            ? null
            : Text(
                "+",
                style: TextStyle(fontSize: 30, color: Color(0xFF848484)),
              ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB7DBC0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB7DBC0)),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Color(0xFFDEDDDD),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
