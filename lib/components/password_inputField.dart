// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/translation.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    Key? key,
    this.controller,
    this.hint,
    this.obscure = false,
    this.maxlines = false,
    this.readOnly = false,
    this.lable,
    this.validator,
    this.autovalidateMode,
    this.toggle,
    this.type = TextInputType.text,
  }) : super(key: key);

  final controller;
  final validator;
  final obscure;
  final hint;
  final type;
  final toggle;
  final lable;
  final autovalidateMode;
  final maxlines;
  final readOnly;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  String? labelTranslation;
  translateLabel() async {
    labelTranslation = await translateText(widget.lable);
    setState(() {});
  }

  @override
  void initState() {
    translateLabel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 65,
      padding: const EdgeInsets.only(top: 15, left: 0, right: 0),
      child: TextFormField(
        readOnly: widget.readOnly,
        obscureText: widget.obscure,
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode ??
            (widget.validator == true.obs
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction),
        style: TextStyle(color: Colors.white),
        keyboardType: widget.type,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                widget.toggle();
              },
              child: widget.obscure
                  ? SvgPicture.asset(
                      'assets/images/emojione-monotone_eye-1.svg',
                      height: 24,
                      color: white,
                      fit: BoxFit.scaleDown,
                    )
                  : SvgPicture.asset(
                      'assets/images/emojione-monotone_eye.svg',
                      height: 24,
                      fit: BoxFit.scaleDown,
                    )
              //  Icon(
              //   obscure
              //       ? Icons.visibility_off_outlined
              //       : Icons.visibility_outlined,
              //   color: Colors.black,
              // ),
              ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          fillColor: Colors.white,
          border: GradientOutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [Color(4285693389), Color(4278253801)]),
            width: 1,
          ),
          hoverColor: Colors.grey,
          focusColor: Colors.grey,
          labelText: labelTranslation ?? '...',
          hintText: widget.hint,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            foreground: Paint()
              ..shader = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [Color(4285693389), Color(4284015103)],
              ).createShader(Rect.fromLTWH(0, 0, 200, 20)),
          ),
        ),
      ),
    );
  }
}
