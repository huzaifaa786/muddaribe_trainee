// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:badges/badges.dart' as badges;

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, this.ontap, this.time, this.image,this.name, this.seen});
  final ontap;
  final time;
  final image;
  final name;
  final seen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 2),
      child: Container(
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: Color(0x21000000),
        //       blurRadius: 28,
        //       offset: Offset(2, 2),
        //       spreadRadius: 0,
        //     )
        //   ],
        // ),
        child: Center(
          child: ListTile(
            leading: SizedBox(
              height: 55,
              width: 59,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: white,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4),
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: badges.Badge(
                    badgeStyle: badges.BadgeStyle(badgeColor: borderDown),
                    showBadge: seen == true ? false : true,
                  ),
                )
              ],
            ),
            subtitle: Text(
              time,
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: white),
            ),
            onTap: ontap,
          ),
        ),
      ),
    );
  }
}
