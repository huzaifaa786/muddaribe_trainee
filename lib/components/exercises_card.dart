import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class ExercisesCard extends StatelessWidget {
  const ExercisesCard(
      {super.key, required this.title, required this.description});
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 15,left: 15,right: 15
      ),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Color(0x872C2723), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Image.asset('assets/images/exercisesimg.png'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
              Text(description,
                  style: TextStyle(
                    color: white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
