// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:gap/gap.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class ChatPlanPopUpCard extends StatelessWidget {
  const ChatPlanPopUpCard(
      {super.key, this.img, this.name, this.price, this.title, this.category});
  final img;
  final name;
  final price;
  final category;
  final title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgContainer,
        borderRadius: BorderRadius.circular(10),
        border: GradientBoxBorder(
          gradient: LinearGradient(colors: [borderTop, borderDown]),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
              blurRadius: 20, offset: Offset(12, 15), color: Colors.black),
          BoxShadow(
              blurRadius: 20, offset: Offset(12, -15), color: Colors.black),
          BoxShadow(
              blurRadius: 20, offset: Offset(-12, 15), color: Colors.black),
          BoxShadow(
              blurRadius: 20, offset: Offset(-12, -15), color: Colors.black)
        ],
      ),
      child: Wrap(
        spacing: 12,
        children: [
          Row(
            children: [
              Material(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  img,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey[300],
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.grey[300],
                    );
                  },
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              Gap(12),
              SizedBox(
                width: 150,
                child: Text(
                  name,
                  style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: white),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                category == 'excercise&nutrition'
                    ? Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/packageplanimage.png',
                                height: 19,
                                width: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Image.asset('assets/images/packageplanimage1.png',
                                  height: 18, width: 20),
                            ],
                          ),
                        ],
                      )
                    : category == 'nutrition'
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'assets/images/packageplanimage1.png',
                              height: 19,
                              width: 20,
                            ))
                        : Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'assets/images/packageplanimage.png',
                              height: 19,
                              width: 20,
                            )),
                Gap(8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: white,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              "Included $category",
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: white,
                    height: 52 / 20,
                  ),
                ),
                Text(
                  "   AED",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: white,
                    height: 32 / 12,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
