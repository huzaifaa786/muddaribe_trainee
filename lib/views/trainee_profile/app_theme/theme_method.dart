// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class ThemeMethod extends StatefulWidget {
  ThemeMethod(
      {Key? key,
      this.value,
      this.groupvalue,
      this.onpress,
      this.onchaged,
      this.image,
      this.title})
      : super(
          key: key,
        );
  final value;
  final onpress;
  final groupvalue;
  final onchaged;
  final image;
  final title;
  @override
  State<ThemeMethod> createState() => _ThemeMethodState();
}

class _ThemeMethodState extends State<ThemeMethod> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onchaged,
      child: Container(
        // margin: EdgeInsets.only(left: 34),
        padding: EdgeInsets.only(top: 7, bottom: 7),
        width: MediaQuery.of(context).size.width * 0.88,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400),
                      ),
                      Transform.scale(
                          scale: 1.2,
                          child: Radio(
                              value: widget.value.toString(),
                              groupValue: widget.groupvalue.toString(),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => borderTop),
                              onChanged: (value) {
                                widget.onchaged();
                              })),
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
