// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class PackageCheckedBox extends StatelessWidget {
  PackageCheckedBox({
    Key? key,
    this.value,
    this.groupvalue,
    this.onpress,
    this.onchanged,
    this.image,
  }) : super(
          key: key,
        );
  final value;
  final onpress;
  final groupvalue;
  final onchanged;
  final image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onchanged,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          title: Transform.translate(
            offset: Offset(0, 0),
            child: Transform.scale(
                scale: 1.2,
                child: Radio(
                    value: value.toString(),
                    groupValue: groupvalue.toString(),
                    activeColor: borderDown,
                    fillColor:
                        MaterialStateColor.resolveWith((states) => borderDown),
                    onChanged: onchanged)),
          ),
          dense: true,
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
        ),
      ),
    );
  }
}
