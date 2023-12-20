import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mudarribe_trainee/components/exercises_card2.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisesScreen2 extends StatefulWidget {
  const ExercisesScreen2({super.key});

  @override
  State<ExercisesScreen2> createState() => _ExercisesScreen2State();
}

class _ExercisesScreen2State extends State<ExercisesScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          TopBar(text: 'Exercises'),
         ExercisesCard2(),
        ],
      )),
    );
  }
}
