// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class Checkedbox extends StatefulWidget {
  Checkedbox({
    Key? key,
    this.value,
    this.groupvalue,
    this.onpress,
    this.onchaged,
    this.image,
    this.staticimage,
    // this.title
  }) : super(
          key: key,
        );
  final value;
  final onpress;
  final groupvalue;
  final onchaged;
  final image;
  // final title;
  final staticimage;
  @override
  State<Checkedbox> createState() => _CheckedboxState();
}

class _CheckedboxState extends State<Checkedbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onchaged,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                          scale: 1.2,
                          child: Radio(
                              value: widget.value.toString(),
                              groupValue: widget.groupvalue.toString(),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => borderDown),
                              onChanged: (value) {
                                widget.onchaged();
                              })),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(widget.staticimage),
                            Text(
                              ('***** 4578'),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // trailing:
                dense: true,
                contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
