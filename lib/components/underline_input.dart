// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class UnderlineInputField extends StatelessWidget {
  const UnderlineInputField({
    Key? key,
    this.controller, this.img,
    this.obscure = false,
    this.maxlines = false,
    this.readOnly = false,
    this.validator,
    this.autovalidateMode,
    this.type = TextInputType.text,
  }) : super(key: key);

  final controller;
  final img;
  final validator;
  final obscure;
  final type;
  final autovalidateMode;
  final maxlines;
  final readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: readOnly,
        obscureText: obscure,
        controller: controller,
        validator: validator,
        autovalidateMode: autovalidateMode ??
            (validator == true.obs
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction),
        style: TextStyle(color: Colors.white),
        keyboardType: type,
        decoration: InputDecoration(
          suffixIcon: SvgPicture.asset(img, height: 20,fit: BoxFit.scaleDown),
            contentPadding:
                EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: borderDown)
            ),
             focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: borderDown)
            ),
            hoverColor: Colors.grey,
            focusColor: Colors.grey));
  }
}
